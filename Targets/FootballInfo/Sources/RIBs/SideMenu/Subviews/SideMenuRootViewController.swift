//
//  SideMenuRootViewController.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/03.
//

import UIKit
import RxSwift
import RxCocoa

protocol SideMenuRootDelegate: AnyObject {
  func didLeagueSelectInRoot(of leagueInfo: LeagueInfo)
}

final class SideMenuRootViewController: UIViewController {
  
  weak var delegate: SideMenuRootDelegate?
  private var currentLeagueInfo: LeagueInfo
  private var disposeBag = DisposeBag()
  
  init(currentLeagueInfo: LeagueInfo) {
    self.currentLeagueInfo = currentLeagueInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let sideTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.separatorStyle = .none
    tableView.register(SideTableViewCell.self,
                       forCellReuseIdentifier: SideTableViewCell.identifier)
    tableView.backgroundColor = .clear
    tableView.rowHeight = 50
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .purple
    viewConfig()
    navConfig()
    constraintsConfig()
    sideTableviewBind()
  }
  
  private func viewConfig() {
    sideTableView.backgroundColor = .clear
    view.backgroundColor = currentLeagueInfo.league.colors[0]
    view.addSubview(sideTableView)
  }
  
  private func constraintsConfig() {
    sideTableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func navConfig() {
    let appearnce = UINavigationBarAppearance()
    appearnce.configureWithOpaqueBackground()
    appearnce.backgroundColor = currentLeagueInfo.league.colors[0]
    navigationController?.navigationBar.standardAppearance = appearnce
    navigationController?.navigationBar.scrollEdgeAppearance = appearnce
  }
  
  private func sideTableviewBind() {
    sideTableView.rx.setDelegate(self).disposed(by: disposeBag)
    
    let currentLeague = currentLeagueInfo.league
    Observable.just(SideSection.league.contents)
      .asDriver(onErrorJustReturn: [])
      .drive(sideTableView.rx.items) { tableView, row, leagueName in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideTableViewCell.identifier) as? SideTableViewCell
        else {
          return UITableViewCell()
        }
        cell.backgroundColor = currentLeague.colors[2]
        cell.configure(with: leagueName)
        return cell
      }.disposed(by: disposeBag)
    
    sideTableView.rx.modelSelected(String.self)
      .asDriver(onErrorJustReturn: "")
      .drive(self.rx.didLeagueSelectInRoot)
      .disposed(by: disposeBag)
      
  }
}

extension Reactive where Base: SideMenuRootViewController {
  var didLeagueSelectInRoot: Binder<String> {
    return Binder(base.self) { vc, leagueName in
      guard let selectedLeague = LeagueInfo.League(rawValue: leagueName) else { return }
      let selectedLeagueInfo = LeagueInfo(league: selectedLeague)
      base.delegate?.didLeagueSelectInRoot(of: selectedLeagueInfo)
    }
  }
}

// MARK: - TableView Delegate
extension SideMenuRootViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    let sideMenuTitle = SideSection.league.title
    label.text = "  \(sideMenuTitle)"
    label.font = .systemFont(ofSize: 25, weight: .bold)
    label.textColor = .white
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
}
