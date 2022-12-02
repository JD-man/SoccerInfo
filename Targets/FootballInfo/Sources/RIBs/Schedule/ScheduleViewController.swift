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
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class ScheduleViewController: UIViewController, SchedulePresentable, ScheduleViewControllable {
  
  weak var listener: SchedulePresentableListener?
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
  private func viewConfig() {
    view.backgroundColor = .systemIndigo
    view.addSubview(schedulesTableView)
  }
  
  private func constraintConfig() {
    schedulesTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
    view.backgroundColor = .systemIndigo
    
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
