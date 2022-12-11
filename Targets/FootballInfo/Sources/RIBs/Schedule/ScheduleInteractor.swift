//
//  ScheduleInteractor.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation
import RIBs
import RxSwift
import ReactorKit

protocol ScheduleRouting: ViewableRouting {
  func attachMatchDetail(
    fixtureId: Int,
    leagueInfo: LeagueInfo,
    headerModel: MatchDetailHeaderModel
  )
  func detachMatchDetail()
}

protocol SchedulePresentable: Presentable {
  var listener: SchedulePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ScheduleListener: AnyObject {
  func attachSideMenu(with currentLeagueInfo: LeagueInfo)
}

protocol ScheduleInteractorDependency {
  var leagueInfoStream: LeagueInfoStreamProtocol { get }
}

final class ScheduleInteractor: PresentableInteractor<SchedulePresentable>,
                                ScheduleInteractable,
                                SchedulePresentableListener,
                                Reactor {
  
  typealias Action = ScheduleReactorModel.Action
  typealias Mutation = ScheduleReactorModel.Mutation
  typealias State = ScheduleReactorModel.State
  
  var viewAction: ActionSubject<ScheduleReactorModel.Action> { action }
  var viewState: Observable<ScheduleReactorModel.State> { state }
  private let dependency: ScheduleInteractorDependency
  
  // TODO: - Date extension 모듈화시 어떻게 사용할지 생각
  var initialState = State(firstDay: Date().fixtureFirstDay)
  
  weak var router: ScheduleRouting?
  weak var listener: ScheduleListener?
  private let useCase: ScheduleUseCaseProtocol
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: SchedulePresentable,
    useCase: ScheduleUseCaseProtocol,
    dependency: ScheduleInteractorDependency
  ) {
    self.useCase = useCase
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}

// MARK: - Reactor
extension ScheduleInteractor {
  
  func mutate(action: Action) -> Observable<Mutation> {
    let firstDay = currentState.firstDay
    let prevWeekFirstDay = firstDay.beforeWeekDay
    let nextWeekFirstDay = firstDay.afterWeekDay
    let leagueInfo = currentState.leagueInfo
    let totalScheduleDictionary = currentState.totalScheduleDictionary
    
    switch action {
    case .fetchSchedule:
      return fetchSchedules(leagueInfo: leagueInfo, firstDay: firstDay)
      
    case .prevSchedule:
      let prevWeekScheduleContent = makeWeeklyScheduleContent(
        firstDay: prevWeekFirstDay,
        totalDictionary: totalScheduleDictionary,
        leagueInfo: leagueInfo
      )
      return .concat(
        .just(.setWeeklyScheduleContent(prevWeekScheduleContent)),
        .just(.setFirstDay(prevWeekFirstDay))
      )
      
    case .nextSchedule:
      let nextWeekScheduleContent = makeWeeklyScheduleContent(
        firstDay: nextWeekFirstDay,
        totalDictionary: totalScheduleDictionary,
        leagueInfo: leagueInfo
      )
      return .concat(
        .just(.setWeeklyScheduleContent(nextWeekScheduleContent)),
        .just(.setFirstDay(nextWeekFirstDay))
      )
      
    case .showSideMenu:
      return .just(.setIsSideMenuShown(true))
        .do(onNext: { [weak self] _ in
          guard let self = self else { return }
          let currentLeagueInfo = self.currentState.leagueInfo
          self.listener?.attachSideMenu(with: currentLeagueInfo)
        })
      
    case .showMatchDetail(let selectedMatch):
      return .just(.setPresentReserveAlert(nil))
        .do(onNext: { [weak self] _ in
          guard let self = self else { return }
          let headerModel = MatchDetailHeaderModel(
            homeScore: "\(selectedMatch.homeGoal ?? 0)",
            awayScore: "\(selectedMatch.awayGoal ?? 0)",
            homeTeamName: selectedMatch.homeName,
            awayTeamName: selectedMatch.awayName
          )
          self.router?.attachMatchDetail(
            fixtureId: selectedMatch.fixtureID,
            leagueInfo: self.currentState.leagueInfo,
            headerModel: headerModel
          )
        })
    
    case .showReserveAlert:
      return .empty()
    }
  }
  
  func transform(mutation: Observable<ScheduleReactorModel.Mutation>) -> Observable<ScheduleReactorModel.Mutation> {
    let firstDay = initialState.firstDay
    let leagueInfoMutation = dependency.leagueInfoStream.leagueInfo
      .withUnretained(self)
      .flatMap { interactor, leagueInfo -> Observable<Mutation> in
        return .concat(
          interactor.fetchSchedules(leagueInfo: leagueInfo, firstDay: firstDay),
          .just(.setLeagueInfo(leagueInfo)),
          .just(.setIsSideMenuShown(false))
        )
      }
    return .merge(mutation, leagueInfoMutation)
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setFirstDay(let firstDay):
      newState.firstDay = firstDay
    case .setTotalScheduleDictionary(let totalScheduleDictionary):
      newState.totalScheduleDictionary = totalScheduleDictionary
    case .setWeeklyScheduleContent(let weeklyScheduleContent):
      newState.weeklyScheduleContent = weeklyScheduleContent
    case .setLeagueInfo(let league):
      newState.leagueInfo = league
    case .setIsSideMenuShown(let isShown):
      newState.isSideMenuShown = isShown
    case .setPresentReserveAlert(let present):
      newState.presentReserveAlert = present
    }
    return newState
  }
}

extension ScheduleInteractor {
  typealias TotalScheduleDictionary = [String: [ScheduleSectionModel.Item]]
  
  private func makeTotalScheduleDictionary(
    data: [FixturesRealmData],
    leagueInfo: LeagueInfo
  ) -> TotalScheduleDictionary {
    
    return data
      .sorted(by: { $0.fixtureDate < $1.fixtureDate })
      .reduce(into: [:]) { partialResult, realmData in
        let date = realmData.fixtureDate.toDate
        let dateHeader = date.formattedDay
        let item = ScheduleSectionModel.Item(leagueInfo: leagueInfo,
                                             homeID: realmData.homeID,
                                             homeName: realmData.homeName,
                                             homeLogo: realmData.homeLogo,
                                             homeGoal: realmData.homeGoal,
                                             awayID: realmData.awayID,
                                             awayName: realmData.awayName,
                                             awayLogo: realmData.awayLogo,
                                             awayGoal: realmData.awayGoal,
                                             matchHour: date.formattedHour,
                                             fixtureID: realmData.fixtureID)
        
        
        guard var newItems = partialResult[dateHeader] else {
          partialResult[dateHeader] = [item]
          return
        }
        newItems.append(item)
        partialResult[dateHeader] = newItems
      }
  }
  
  private func makeWeeklyScheduleContent(
    firstDay: Date,
    totalDictionary: TotalScheduleDictionary,
    leagueInfo: LeagueInfo
  ) -> [ScheduleSectionModel] {
      
    return [Int](0 ..< 7)
      .map { after -> ScheduleSectionModel in
        guard let dateHeader = Calendar.CalendarKST.date(byAdding: .day, value: after, to: firstDay)?.formattedDay else {
          return .init(dateHeader: "Date nil", items: [] )
        }
        
        guard let items = totalDictionary[dateHeader] else {
          return .init(dateHeader: dateHeader, items: [
            .emptyContent(id: after, leagueInfo: leagueInfo)])
        }
        
        return .init(dateHeader: dateHeader, items: items)
      }
  }
  
  private func fetchSchedules(leagueInfo: LeagueInfo, firstDay: Date) -> Observable<Mutation> {
    let season = leagueInfo.season
    let league = "\(leagueInfo.league.leagueID)"
    return useCase.executeRealmFixture(season: season, league: league)
      .withUnretained(self)
      .flatMap { interactor, data -> Observable<Mutation> in
        let totalScheduleDictionary = interactor.makeTotalScheduleDictionary(
          data: data,
          leagueInfo: leagueInfo
        )
        let weeklyScheduleContent = interactor.makeWeeklyScheduleContent(
          firstDay: firstDay,
          totalDictionary: totalScheduleDictionary,
          leagueInfo: leagueInfo
        )
        return .concat(
          .just(.setTotalScheduleDictionary(totalScheduleDictionary)),
          .just(.setWeeklyScheduleContent(weeklyScheduleContent))
        )
      }
  }
}
