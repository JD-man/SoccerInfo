//
//  ScheduleViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/18.
//

import UIKit

class ScheduleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        print(Date().today, Date().today.nextDay)
        //viewConfig()
    }
    
    func viewConfig() {        
    }
    
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        
        deleteRealmDataAll()
    }
    
    
    
}
