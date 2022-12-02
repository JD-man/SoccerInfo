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
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SchedulePresentable: Presentable {
  var listener: SchedulePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ScheduleListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ScheduleInteractor: PresentableInteractor<SchedulePresentable>,
                                ScheduleInteractable,
                                SchedulePresentableListener,
                                Reactor {
  
  var viewAction: ActionSubject<ScheduleReactorModel.Action> { action }
  var viewState: Observable<ScheduleReactorModel.State> { state }
  
  typealias Action = ScheduleReactorModel.Action
  typealias Mutation = ScheduleReactorModel.Mutation
  typealias State = ScheduleReactorModel.State
  
  // TODO: - Date extension 모듈화시 어떻게 사용할지 생각
  var initialState = State(firstDay: Date().fixtureFirstDay)
  
  weak var router: ScheduleRouting?
  weak var listener: ScheduleListener?
  private let useCase: ScheduleUseCaseProtocol
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: SchedulePresentable,
    useCase: ScheduleUseCaseProtocol
  ) {
    self.useCase = useCase
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
    switch action {
    case .fetchSchedule:
      return useCase.executeRealmFixture(season: 2022, league: "39")
        .withUnretained(self)
        .flatMap { interactor, data -> Observable<Mutation> in
          let firstDay = interactor.currentState.firstDay
          let totalScheduleDictionary = interactor.makeTotalScheduleDictionary(data: data)
          let weeklyScheduleContent = interactor.makeWeeklyScheduleContent(
            firstDay: firstDay,
            totalDictionary: totalScheduleDictionary
          )
          return .concat(
            .just(.setTotalScheduleDictionary(totalScheduleDictionary)),
            .just(.setWeeklyScheduleContent(weeklyScheduleContent))
          )
        }
      
    case .prevSchedule:
      let prevWeekFirstDay = currentState.firstDay.beforeWeekDay
      let totalScheduleDictionary = currentState.totalScheduleDictionary
      let prevWeekScheduleContent = makeWeeklyScheduleContent(
        firstDay: prevWeekFirstDay,
        totalDictionary: totalScheduleDictionary
      )
      return .concat(
        .just(.setWeeklyScheduleContent(prevWeekScheduleContent)),
        .just(.setFirstDay(prevWeekFirstDay))
      )
      
    case .nextSchedule:
      let nextWeekFirstDay = currentState.firstDay.afterWeekDay
      let totalScheduleDictionary = currentState.totalScheduleDictionary
      let nextWeekScheduleContent = makeWeeklyScheduleContent(
        firstDay: nextWeekFirstDay,
        totalDictionary: totalScheduleDictionary
      )
      return .concat(
        .just(.setWeeklyScheduleContent(nextWeekScheduleContent)),
        .just(.setFirstDay(nextWeekFirstDay))
      )
    }
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
    }
    return newState
  }
}

extension ScheduleInteractor {
  typealias TotalScheduleDictionary = [String: [ScheduleSectionModel.Item]]
  
  private func makeTotalScheduleDictionary(data: [FixturesRealmData]) -> TotalScheduleDictionary {
    
    return data
      .sorted(by: { $0.fixtureDate < $1.fixtureDate })
      .reduce(into: [:]) { partialResult, realmData in
        let date = realmData.fixtureDate.toDate
        let dateHeader = date.formattedDay
        let item = ScheduleSectionModel.Item(homeID: realmData.homeID,
                                             homeName: realmData.homeName,
                                             homeLogo: realmData.homeLogo,
                                             awayID: realmData.awayID,
                                             awayName: realmData.awayName,
                                             awayLogo: realmData.awayLogo,
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
    totalDictionary: TotalScheduleDictionary) -> [ScheduleSectionModel] {
      
    return [Int](0 ..< 7)
      .map { after -> ScheduleSectionModel in
        guard let dateHeader = Calendar.CalendarKST.date(byAdding: .day, value: after, to: firstDay)?.formattedDay else {
          return .init(dateHeader: "Date nil", items: [] )
        }
        
        guard let items = totalDictionary[dateHeader] else {
          return .init(dateHeader: dateHeader, items: [.emptyContent(id: after)])
        }
        
        return .init(dateHeader: dateHeader, items: items)
      }
  }
}
