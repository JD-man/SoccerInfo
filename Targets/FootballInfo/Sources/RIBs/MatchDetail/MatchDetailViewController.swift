//
//  MatchDetailViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import RIBs
import RxSwift
import UIKit

protocol MatchDetailPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class MatchDetailViewController: UIViewController, MatchDetailPresentable, MatchDetailViewControllable {
  
  weak var listener: MatchDetailPresentableListener?
}
