//
//  MatchDetailViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/04.
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import ReactorKit

protocol MatchDetailPresentableListener: AnyObject {
  var viewAction: ActionSubject<MatchDetailReactorModel.Action> { get }
  var viewState: Observable<MatchDetailReactorModel.State> { get }
}

final class MatchDetailViewController: UIViewController, MatchDetailPresentable, MatchDetailViewControllable {
  
  weak var listener: MatchDetailPresentableListener?
  
  private var activityView = UIActivityIndicatorView()
  private let headerView = MatchDetailTableHeaderView()
  
  private var disposeBag = DisposeBag()
  
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
    bindAction()
    bindState()
    bindEtc()
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
  
  private func bindAction() {
    guard let listener = listener else { return }
    
  }
  
  private func bindState() {
    guard let listener = listener else { return }
    leagueInfo(listener: listener)
    headerModel(listener: listener)
  }
  
  private func bindEtc() {
    
  }
}

// MARK: - Action
extension MatchDetailViewController {
}

// MARK: - State
extension MatchDetailViewController {
  private func leagueInfo(listener: MatchDetailPresentableListener) {
    listener.viewState
      .map(\.leagueInfo.league)
      .asDriver(onErrorJustReturn: .premierLeague)
      .drive { [weak self] in
        self?.gradient.colors = [$0.colors[0].cgColor, $0.colors[1].cgColor]
      }.disposed(by: disposeBag)
  }
  
  private func headerModel(listener: MatchDetailPresentableListener) {
    listener.viewState
      .map(\.headerModel)
      .asDriver(onErrorJustReturn: .init(homeScore: "", awayScore: "", homeTeamName: "", awayTeamName: ""))
      .drive { [weak self] in
        self?.headerView.configure(with: $0)
      }.disposed(by: disposeBag)
  }
}

// MARK: - Etc {
extension MatchDetailViewController {
}

