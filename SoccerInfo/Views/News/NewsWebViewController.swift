//
//  NewsWeblViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/26.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {
    deinit {
        print("deinit news webview")
    }

    @IBOutlet weak var newsWebView: WKWebView!
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    func viewConfig() {
        guard let newsURL = URL(string: url) else { return }
        let newsRequest = URLRequest(url: newsURL)
        newsWebView.load(newsRequest)
    }
}
