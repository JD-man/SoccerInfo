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
    tableView.backgroundColor = .red
    tableView.separatorInset.right = tableView.separatorInset.left
    tableView.rowHeight = 70
    tableView.register(ScheduleTableViewCell.self,
                       forCellReuseIdentifier: ScheduleTableViewCell.identifier)
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
    view.backgroundColor = .systemIndigo
    view.addSubview(schedulesTableView)
  }
  
  private func constraintConfig() {
    schedulesTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindAction() {
    guard let listner = listener else { return }
    
    Observable.just(Void())
      .map { ScheduleReactorModel.Action.fetchSchedule }
      .bind(to: listner.viewAction)
      .disposed(by: disposeBag)
    
    view.rx
      .swipeGesture(.left)
      .when(.ended)
      .skip(1)
      .map { _ in ScheduleReactorModel.Action.nextSchedule }
      .bind(to: listner.viewAction)
      .disposed(by: disposeBag)
    
    view.rx
      .swipeGesture(.right)
      .when(.ended)
      .skip(1)
      .map { _ in ScheduleReactorModel.Action.prevSchedule }
      .bind(to: listner.viewAction)
      .disposed(by: disposeBag)
  }
  
  private func bindState() {
    guard let listner = listener else { return }
    listner.viewState
      .map(\.weeklyScheduleContent)
      .asDriver(onErrorJustReturn: [])
      .drive(schedulesTableView.rx.items(dataSource: self.dataSources))
      .disposed(by: disposeBag)
  }
  
  private func bindEtc() {
    schedulesTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension ScheduleViewController {
  private func scheduleTableViewDataSources() -> ScheduleDataSources {
    return ScheduleDataSources { dataSource, tableView, indexPath, item in
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: ScheduleTableViewCell.identifier,
        for: indexPath) as? ScheduleTableViewCell
      else {
        return ScheduleTableViewCell() }
      cell.configure(with: item)
      return cell
    }
  }
}

extension ScheduleViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    let dateHeader = dataSources[section].dateHeader
    let isMatchDay = dateHeader.sectionTitleToDate.dayStart == Date().dayStart
    let headerText = isMatchDay ? "  \(dateHeader)" : "  \(dateHeader) ⚽️"
    
    label.textColor = .white
    label.text = headerText
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}
