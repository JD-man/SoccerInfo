//
//  NewsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import Kingfisher
import SafariServices

class NewsViewController: BasicTabViewController<NewsData> {
    typealias SearchResponse = Result<NewsResponse, Error>
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var totalPage: Int = 0
    var start: Int = 1
    
    override var league: League {
        didSet {
            fetchNewsAPIData()
        }
    }
    
    override var data: [NewsData] {
        didSet {
            if activityView.isAnimating {
                activityView.stopAnimating()
            }
            newsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewsAPIData()
    }
    
    override func viewConfig() {
        super.viewConfig()        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.separatorInset.left = newsTableView.separatorInset.right
        
        newsTableView.layer.shadowRadius = 5
        newsTableView.layer.shadowOpacity = 1
        newsTableView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func fetchNewsAPIData() {
        activityView.startAnimating()
        // News Search Query
        let query = URLQueryItem(name: "query", value: "\(league.newsQuery)")
        let start = URLQueryItem(name: "start", value: "1")
        let display = URLQueryItem(name: "display", value: "10")
        let url = APIComponents.newsRootURL.toURL(of: .newsSearch,
                                                      queryItems: [query, start, display])
        
        
        let group = DispatchGroup()
        // News Search
        fetchAPIData(of: .newsSearch, url: url) { [weak self] (result: SearchResponse) in
            switch result {
            case .success(let newsResponse):
                self?.totalPage = min(self!.totalPage, 100)
                var items = newsResponse.items
                if items.isEmpty { return }
                
                var randomIndex: Set<Int> = [0]
                let minCount = min(items.count, 3)
                while randomIndex.count < minCount {
                    randomIndex.insert(Int.random(in: 0 ..< minCount))
                }
                
                // News Image Search by News title
                for i in randomIndex {
                    group.enter()                    
                    let query = URLQueryItem(name: "query", value: items[i].title!.removeSearchTag)
                    let display = URLQueryItem(name: "display", value: "1")
                    let sort = URLQueryItem(name: "sort", value: "sim")
                    let url = APIComponents.newsRootURL.toURL(of: .newsImage,
                                                              queryItems: [query, display, sort])
                    
                    self?.fetchAPIData(of: .newsImage, url: url) { (result: SearchResponse) in
                        switch result {
                        case .success(let newsResponse):
                            if newsResponse.items.isEmpty == false {
                                items[i].imageURL = newsResponse.items[0].link
                            }
                            group.leave()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                group.notify(queue: .main, execute: {
                    self?.data = items
                })
            case .failure(let erorr):
                print(erorr)
            }
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                 for: indexPath) as! NewsTableViewCell
        cell.configure(with: data[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newsLink = data[indexPath.section].link,
              let newsURL = URL(string: newsLink) else { return }
        // safari
        let safariVC = SFSafariViewController(url: newsURL)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true, completion: nil)
    }
}
