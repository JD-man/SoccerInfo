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
import RxDataSources

protocol MatchDetailPresentableListener: AnyObject {
  var viewAction: ActionSubject<MatchDetailReactorModel.Action> { get }
  var viewState: Observable<MatchDetailReactorModel.State> { get }
}

final class MatchDetailViewController: UIViewController, MatchDetailPresentable, MatchDetailViewControllable {
  typealias MatchDetailDataSources = RxTableViewSectionedAnimatedDataSource<MatchDetailSectionModel>
  
  weak var listener: MatchDetailPresentableListener?
  
  private var activityView = UIActivityIndicatorView()
  private let headerView = MatchDetailTableHeaderView()
  
  private var disposeBag = DisposeBag()
  private lazy var dataSources = matchDetailDataSources()
  
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
    Observable.just(Void())
      .map { MatchDetailReactorModel.Action.fetchMatchDetail }
      .bind(to: listener.viewAction)
      .disposed(by: disposeBag)
  }
  
  private func bindState() {
    guard let listener = listener else { return }
    leagueInfo(listener: listener)
    headerModel(listener: listener)
    matchDetailTableView(listner: listener)
  }
  
  private func bindEtc() {
    bindTableViewDelegate()
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
  
  private func matchDetailTableView(listner: MatchDetailPresentableListener) {
    listner.viewState
      .map(\.matchDetailSection)
      .asDriver(onErrorJustReturn: [])
      .drive(matchDetailTableView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
}

// MARK: - MatchDetail TableView DataSources
extension MatchDetailViewController {
  private func matchDetailDataSources() -> MatchDetailDataSources {
    return MatchDetailDataSources { dataSource, tableView, indexPath, item in
      switch item {
      case .eventCell(let eventEntity, let isHomeCell):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: EventsTableViewCell.identifier,
          for: indexPath) as? EventsTableViewCell
        else {
          return EventsTableViewCell()
        }
        cell.configure(with: eventEntity, isHomeCell: isHomeCell)
        return cell
        
      case .formationCell(let homeLineup, let awayLineup):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: FormationTableViewCell.identifier,
          for: indexPath) as? FormationTableViewCell
        else {
          return FormationTableViewCell()
        }
        cell.configure(homeLineup: homeLineup, awayLineup: awayLineup)
        return cell
        
      case .startingLineupCell(let homeLineup, let awayLineup, let leagueInfo):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: LineupsTableViewCell.identifier,
          for: indexPath) as? LineupsTableViewCell
        else {
          return LineupsTableViewCell()
        }
        cell.configure(homeLineup: homeLineup, awayLineup: awayLineup, leagueInfo: leagueInfo)
        return cell
        
      case .benchLineupCell(let homeSubLineup, let awaySubLineup, let leagueInfo):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: LineupsTableViewCell.identifier,
          for: indexPath) as? LineupsTableViewCell
        else {
          return LineupsTableViewCell()
        }
        cell.configure(homeLineup: homeSubLineup, awayLineup: awaySubLineup, leagueInfo: leagueInfo)
        return cell
      }
    }
  }
}

// MARK: - Etc {
extension MatchDetailViewController {
  private func bindTableViewDelegate() {
    matchDetailTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension MatchDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    let sectionTitle = dataSources[section].section.rawValue
    label.textColor = .white
    label.text = sectionTitle
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = indexPath.section
    if section == 0 {
      return UITableView.automaticDimension
//
//      var height: CGFloat = 0
//      let minHeight: CGFloat = 55
//      let totalHeight: CGFloat = 270
//
//      if item == 0 {
//        let currTime = CGFloat(dataSources[section].events[item].time)
//        height = currTime/90 * totalHeight
//      }
//      else {
//        let currTime = matchDetailData.events[item].time
//        let prevTime = matchDetailData.events[item - 1].time
//        let interval = CGFloat(currTime - prevTime)
//        height = interval/90 * totalHeight
//      }
//      return height >= minHeight ? height : minHeight
    }
    else if section == 1 {
      return 240
    }
    else {
      return 50
    }
  }
}
