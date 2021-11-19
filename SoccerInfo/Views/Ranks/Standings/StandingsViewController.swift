//
//  StandingsViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit

class StandingsViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        viewConfig()
    }
    
    func viewConfig() {
        
    }
    
//    func fetchData() {
//        guard let filePath = Bundle.main.path(forResource: "Standing", ofType: "json"),
//              let jsonString = try? String(contentsOfFile: filePath) else {
//                  return
//              }
//              
//        let standings = try? JSONDecoder().decode(StandingResponse.self, from: jsonString.data(using: .utf8)!)
//        print(standings)
//    }
}
