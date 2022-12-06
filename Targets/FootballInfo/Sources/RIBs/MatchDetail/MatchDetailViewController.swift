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
  
  private var activityView = UIActivityIndicatorView()
  private let headerView = MatchDetailTableHeaderView()
  
  private lazy var gradient: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.locations = [0.0, 1.0]
    gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
    return gradient
  }()
  
  private let matchDetailTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.register(EventsTableViewCell.self,
                       forCellReuseIdentifier: EventsTableViewCell.identifier)
    tableView.register(LineupsTableViewCell.self,
                       forCellReuseIdentifier: LineupsTableViewCell.identifier)
    tableView.register(FormationTableViewCell.self,
                       forCellReuseIdentifier: FormationTableViewCell.identifier)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewConfig()
    constraintsConfig()
  }
  
  private func viewConfig() {
    title = "경기정보"
    view.addSubview(matchDetailTableView)
    view.layer.insertSublayer(gradient, at: 0)
    matchDetailTableView.tableHeaderView = headerView
  }
  
  private func constraintsConfig() {
    matchDetailTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide).inset(15)
    }
  }
}
