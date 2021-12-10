//
//  ManualViewController.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/12/02.
//

import UIKit

class ManualViewController: UIViewController {
    
    let manualImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ManualVC")        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        manualImageViewConfig()
    }
    
    func manualImageViewConfig() {
        view.addSubview(manualImageView)
        manualImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                              constant: 15).isActive = true
        manualImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                              constant: -15).isActive = true
        manualImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: 15).isActive = true
        manualImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -15).isActive = true
    }
}
