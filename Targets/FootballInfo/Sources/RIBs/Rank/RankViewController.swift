//
//  RankViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift
import UIKit

protocol RankPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class RankViewController: UIViewController, RankPresentable, RankViewControllable {
  
  weak var listener: RankPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .cyan
    
  }
}
