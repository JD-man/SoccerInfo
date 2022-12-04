//
//  SideMenuViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/03.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import SideMenu

protocol SideMenuPresentableListener: AnyObject {
  func didLeagueSelectedInSideMenu(of leagueInfo: LeagueInfo)
  func dismissSideMenu()
}

final class SideMenuViewController: SideMenuNavigationController, SideMenuPresentable, SideMenuViewControllable {
  
  weak var listener: SideMenuPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let presentationStyle = SideMenuPresentationStyle.menuSlideIn
    presentationStyle.presentingScaleFactor = 0.95
    presentationStyle.presentingEndAlpha = 0.35
    
    leftSide = true
    menuWidth = view.bounds.width * 0.6
    self.presentationStyle = presentationStyle
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    listener?.dismissSideMenu()
  }
}

extension SideMenuViewController: SideMenuRootDelegate {
  func didLeagueSelectInRoot(of leagueInfo: LeagueInfo) {
    listener?.didLeagueSelectedInSideMenu(of: leagueInfo)
  }
}
