//
//  SquadsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit
import RealmSwift
import Kingfisher

// current 10 match results collection view -> horizontal scroll
// curretn 10 match win rate Pie Chart

// Fixtures Data -> filtering completed match by score

class SquadsViewController: UIViewController {
    
    deinit {
        print("SquadVC deinit")
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var labelContainerView: UIView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var currentRankLabel: UILabel!
    @IBOutlet weak var rankDescriptionLabel: UILabel!
    
    @IBOutlet weak var currentMatchCollectionView: UICollectionView!
    
    var id: Int = 0
    var logoURL: String = ""
    var currentRank: Int = 0
    var teamName: String = ""
    
    
    // FixturesRealmData
    private var data: [FixturesRealmData] = [] {
        didSet {
            currentMatchCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        loadCurrentMatchData()
    }
    
    func viewConfig() {
        // logo imageview config
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.kf.setImage(with: URL(string: logoURL))
        
        // label container view shadow
        labelContainerView.addShadow()
        
        // labels config
        teamNameLabel.textAlignment = .center
        currentRankLabel.textAlignment = .center
        rankDescriptionLabel.textAlignment = .center
        
        teamNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currentRankLabel.font = .systemFont(ofSize: 19, weight: .medium)
        rankDescriptionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        teamNameLabel.text = teamName
        currentRankLabel.text = "\(currentRank)등"
        
        // collection view config
        currentMatchCollectionView.delegate = self
        currentMatchCollectionView.dataSource = self
        currentMatchCollectionView.showsVerticalScrollIndicator = false
        currentMatchCollectionView.showsHorizontalScrollIndicator = false
        currentMatchCollectionView.collectionViewLayout = CurrentMatchCollectionViewFlowLayout()
        currentMatchCollectionView.register(UINib(nibName: "CurrentMatchCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier: CurrentMatchCollectionViewCell.identifier)
        
        currentMatchCollectionView.decelerationRate = .fast
        currentMatchCollectionView.backgroundColor = .clear
        currentMatchCollectionView.addShadow()
    }
    
    func loadCurrentMatchData() {
        let league = PublicPropertyManager.shared.league
        let season = PublicPropertyManager.shared.season
        
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else {
            alertWithCheckButton(title: "서버 접속에 실패했습니다",
                                 message: "네트워크 연결 상태를 확인하고 다시 시도해주세요.",
                                 completion: nil)
            return
        }
        print("FetchRealmData", user)
        let configuration = user.configuration(partitionValue: "\(league.leagueID)")
        do {
            // Local Realm Load
            print("Local Realm Load")
            let localRealm = try Realm(configuration: configuration)
            
            // check league, season, updateDate
            let objects = localRealm.objects(FixturesTable.self).where {
                $0._partition == "\(league.leagueID)" &&
                $0.season == season
            }
            
            let teamFixture = objects[0].content.where { [weak self] in
                ($0.homeID == self!.id || $0.awayID == self!.id) &&
                $0.homeGoal != nil }
                .sorted { $0.fixtureDate > $1.fixtureDate }
            
            let fixtureCount = min(10, teamFixture.count)
            data = Array(0 ..< fixtureCount).map { return teamFixture[$0] }
        }
        catch {
            alertWithCheckButton(title: "데이터를 불러오는데 실패했습니다.",
                                 message: "",
                                 completion: nil)
        }
    }
}

extension SquadsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentMatchCollectionViewCell.identifier, for: indexPath) as! CurrentMatchCollectionViewCell
        
        let fixture = data[indexPath.row]
        let isHome = fixture.homeID == id ? true : false
        
        cell.configure(with: data[indexPath.row], isHome: isHome)
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let flowLayout = currentMatchCollectionView.collectionViewLayout as! CurrentMatchCollectionViewFlowLayout
        
        let offset: CGFloat = flowLayout.itemSize.width
        
        let estimatedIndex = scrollView.contentOffset.x / offset
        var index = 0
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        }
        else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        }
        else {
            index = Int(round(estimatedIndex))
        }
        
        let x = (CGFloat(index) * offset) + (CGFloat(index - 1) * flowLayout.sectionInset.left)
        targetContentOffset.pointee = CGPoint(x: x, y: 0)
    }
}
