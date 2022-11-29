//
//  NewsViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift
import UIKit

protocol NewsPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class NewsViewController: UIViewController, NewsPresentable, NewsViewControllable {
  
  weak var listener: NewsPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemPink
  }
}
