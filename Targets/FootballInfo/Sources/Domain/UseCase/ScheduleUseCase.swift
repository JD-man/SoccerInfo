//
//  ScheduleUseCase.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import RxSwift

protocol ScheduleUseCaseProtocol {
  func executeRealmFixture(season: Int, league: String) -> Observable<[FixturesRealmData]>
}

final class ScheduleUseCase: ScheduleUseCaseProtocol {
  
  private let footballRepository: FootballRepositoryProtocol
  private let footballRealmRepository: FootballRealmRepositoryProtocol
  
  init(
    footballRepository: FootballRepositoryProtocol,
    footballRealmRepository: FootballRealmRepositoryProtocol
  ) {
    self.footballRepository = footballRepository
    self.footballRealmRepository = footballRealmRepository
  }
  
  func executeRealmFixture(season: Int, league: String) -> Observable<[FixturesRealmData]> {
    return footballRealmRepository.fixture(season: season, league: league)
      .map { Array($0.content) }
      .catch { [weak self] error in
        guard let self = self,
              let error = error as? RealmErrorType
        else { return .error(ScheduleError.realmErrorCastingFail) }
        
        switch error {
        case .emptyData:
          return self.executeFixture(season: season, league: league)
        default:
          print(error)
          return .error(ScheduleError.realmDefaultError)
        }
      }
  }
  
  private func executeFixture(season: Int, league: String) -> Observable<[FixturesRealmData]> {
    return footballRepository.fixture(season: season, league: league)
      .withUnretained(self)
      .flatMap { useCase, fixturesData -> Observable<[FixturesRealmData]> in
        guard fixturesData.results != 0 else { return .error(ScheduleError.emptyResult) }
        let fixturesData = fixturesData.response.map { FixturesRealmData(fixtureResponse: $0) }
        useCase.footballRealmRepository.updateFixture(fixturesData: fixturesData, season: season, league: league)
        return .just(fixturesData)
      }
    
  }
}

