//
//  ScheduleViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import RxGesture
import SnapKit

protocol SchedulePresentableListener: AnyObject {
  var viewAction: ActionSubject<ScheduleReactorModel.Action> { get }
  var viewState: Observable<ScheduleReactorModel.State> { get }
}

final class ScheduleViewController: UIViewController,
                                    SchedulePresentable,
                                    ScheduleViewControllable {
  typealias ScheduleDataSources = RxTableViewSectionedAnimatedDataSource<ScheduleSectionModel>
  
  private var disposeBag = DisposeBag()
  weak var listener: SchedulePresentableListener?
  private lazy var dataSources = scheduleTableViewDataSources()
  
  private let schedulesTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.separatorInset.right = tableView.separatorInset.left
    tableView.rowHeight = 70
    tableView.register(ScheduleTableViewCell.self,
                       forCellReuseIdentifier: ScheduleTableViewCell.identifier)
    return tableView
  }()
  
  fileprivate let sideMenuButton: UIBarButtonItem = {
    let item = UIBarButtonItem()
    item.style = .plain
    item.tintColor = .link
    return item
  }()
  
  fileprivate lazy var gradient: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.frame = self.view.bounds
    gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
    gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradient.locations = [0.0, 1.0]
    return gradient
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
    view.backgroundColor = .clear
    view.addSubview(schedulesTableView)
    navigationItem.leftBarButtonItem = sideMenuButton
    view.layer.insertSublayer(gradient, at: 0)
  }
  
  private func constraintConfig() {
    schedulesTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindAction() {
    guard let listener = listener else { return }
    viewDidLoadFetch(listener: listener)
    swipe(listener: listener)
    sideMenuButton(listener: listener)
    matchDetail(listner: listener)
  }
  
  private func bindState() {
    guard let listener = listener else { return }
    weeklyScheduleContent(listener: listener)
    league(listener: listener)
  }
  
  private func bindEtc() {
    tableViewDelegate()
  }
}

// MARK: - Action
extension ScheduleViewController {
  private func viewDidLoadFetch(listener: SchedulePresentableListener) {
    Observable.just(Void())
      .map { ScheduleReactorModel.Action.fetchSchedule }
      .bind(to: listener.viewAction)
      .disposed(by: disposeBag)
  }
  
  private func swipe(listener: SchedulePresentableListener) {
    let swipe = view.rx
      .swipeGesture([.left, .right])
      .when(.ended)
      .skip(1)
      .publish()
    
    swipe
      .filter { $0.direction == .left }
      .map { _ in ScheduleReactorModel.Action.nextSchedule }
      .bind(to: listener.viewAction)
      .disposed(by: disposeBag)
    
    swipe
      .filter { $0.direction == .right }
      .map { _ in ScheduleReactorModel.Action.prevSchedule }
      .bind(to: listener.viewAction)
      .disposed(by: disposeBag)
    
    swipe.connect().disposed(by: disposeBag)
  }
  
  private func sideMenuButton(listener: SchedulePresentableListener) {
    sideMenuButton.rx.tap
      .map { ScheduleReactorModel.Action.showSideMenu }
      .bind(to: listener.viewAction)
      .disposed(by: disposeBag)
  }
  
  private func matchDetail(listner: SchedulePresentableListener) {
    schedulesTableView.rx.modelSelected(ScheduleSectionModel.Item.self)
      .map { ScheduleReactorModel.Action.showMatchDetail($0) }
      .bind(to: listner.viewAction)
      .disposed(by: disposeBag)
  }
}

// MARK: - State
extension ScheduleViewController {
  private func weeklyScheduleContent(listener: SchedulePresentableListener) {
    listener.viewState
      .map(\.weeklyScheduleContent)
      .asDriver(onErrorJustReturn: [])
      .drive(schedulesTableView.rx.items(dataSource: self.dataSources))
      .disposed(by: disposeBag)
  }
  
  private func league(listener: SchedulePresentableListener) {
    listener.viewState
      .map(\.leagueInfo)
      .asDriver(onErrorJustReturn: .init(league: .premierLeague))
      .drive(self.rx.updateLeague)
      .disposed(by: disposeBag)
  }
}

// MARK: - Etc {
extension ScheduleViewController {
  private func tableViewDelegate() {
    schedulesTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

// MARK: - RxDataSources
extension ScheduleViewController {
  private func scheduleTableViewDataSources() -> ScheduleDataSources {
    return ScheduleDataSources { dataSource, tableView, indexPath, item in
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ScheduleTableViewCell.identifier,
        for: indexPath) as? ScheduleTableViewCell
      else {
        return ScheduleTableViewCell()
      }
      cell.configure(with: item)
      return cell
    }
  }
}

// MARK: - TableView Delegate
extension ScheduleViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    let dateHeader = dataSources[section].dateHeader
    let isMatchDay = dateHeader.sectionTitleToDate.dayStart == Date().dayStart
    let headerText = isMatchDay ? "  \(dateHeader) ⚽️" : "  \(dateHeader)"
    
    label.textColor = .white
    label.text = headerText
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}

// MARK: - Match Detail Navigating
extension ScheduleViewController {
  func pushMatchDetail(_ viewControllable: RIBs.ViewControllable) {
    navigationController?.pushViewController(viewControllable.uiviewController, animated: true)
  }
  
  func popMatchDetail() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Reactive exetension
// TODO: - Common
extension Reactive where Base: ScheduleViewController {
  var updateLeague: Binder<LeagueInfo> {
    return Binder(base.self) { vc, leagueInfo in
      let league = leagueInfo.league
      base.sideMenuButton.title = league.rawValue
      let upperColor = league.colors[0]
      let bottomColor = league.colors[1]
      let colors = [upperColor.cgColor, bottomColor.cgColor]
      base.gradient.colors = colors
      base.navigationController?.navigationBar.standardAppearance.backgroundColor = upperColor
    }
  }
}
