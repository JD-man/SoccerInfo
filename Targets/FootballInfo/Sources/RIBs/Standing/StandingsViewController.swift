//
//  StandingsViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RIBs
import RxSwift
import UIKit
import ReactorKit

protocol StandingsPresentableListener: AnyObject {
  var viewAction: ActionSubject<StandingsReactorModel.Action> { get }
  var viewState: Observable<StandingsReactorModel.State> { get }
}

final class StandingsViewController: UIViewController, StandingsPresentable, StandingsViewControllable {
  
  weak var listener: StandingsPresentableListener?
  
  private var disposeBag = DisposeBag()
  
  private let standingsTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.layer.borderColor = UIColor.label.cgColor
    tableView.register(StandingsTableViewCell.self,
                       forCellReuseIdentifier: StandingsTableViewCell.identifier)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewConfig()
    constraintConfig()
    bindAction()
    bindState()
    bindEtc()
  }
  
  private func viewConfig() {
    view.backgroundColor = .secondarySystemGroupedBackground
    view.addSubview(standingsTableView)
//    navigationItem.leftBarButtonItem = sideMenuButton
  }
  
  private func constraintConfig() {
    standingsTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindAction() {
    guard let listener = listener else { return }
    viewDidLoadFetch(listener: listener)
  }
  
  private func bindState() {
    guard let listener = listener else { return }
    
  }
  
  private func bindEtc() {
    
  }
}

extension StandingsViewController {
  private func viewDidLoadFetch(listener: StandingsPresentableListener) {
    Observable.just(Void())
      .map { StandingsReactorModel.Action.fetchStandings }
      .bind(to: listener.viewAction)
      .disposed(by: disposeBag)
  }
}
