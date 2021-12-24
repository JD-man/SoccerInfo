//
//  OpenSourceLicenseViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/02.
//

import UIKit

class OpenSourceLicenseViewController: UIViewController {

    let openSourceTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        openSourceTextViewConfig()
    }
    
    func openSourceTextViewConfig() {
        view.addSubview(openSourceTextView)
        let alamofire = "Alamofire \n https://github.com/Alamofire/Alamofire/blob/master/LICENSE \n Copyright 2014-2021 Alamofire Software Foundation (http://alamofire.org/) \n MIT License \n\n"
        let sideMenu = "SideMenu \n https://github.com/jonkykong/SideMenu/blob/master/LICENSE \n Copyright 2015 Jonathan Kent <contact@jonkent.me> \n MIT License \n\n"
        let kingFisher = "Kingfisher \n https://github.com/onevcat/Kingfisher/blob/master/LICENSE \n Copyright 2019 Wei Wang \n MIT License \n\n"
        let realm = "Realm-Cocoa \n https://github.com/realm/realm-cocoa/blob/master/LICENSE \n Copyright  2016 Realm Inc. \n Apache License 2.0 \n\n"
        let charts = "Charts \n https://github.com/danielgindi/Charts/blob/master/LICENSE \n Copyright 2016-2019 Daniel Cohen Gindi & Philipp Jahoda \n Apache License 2.0 \n\n"
        let firebase = "Google Firebase \n https://firebase.google.com/docs/ios/setup \n Copyright 2015 Google Inc. \n Apache License 2.0 \n\n"
        
        
        openSourceTextView.text = alamofire + sideMenu + kingFisher + realm + charts + firebase
        
        openSourceTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                 constant: 15).isActive = true
        openSourceTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                  constant: -15).isActive = true
        openSourceTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: 15).isActive = true
        openSourceTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -15).isActive = true
    }

}
