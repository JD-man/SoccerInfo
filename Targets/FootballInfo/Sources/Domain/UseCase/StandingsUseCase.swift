//
//  StandingsUseCase.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/11.
//

import Foundation
import RxSwift

protocol StandingsUseCaseProtocol: AnyObject {
  func executeRealmStanding(season: Int, league: String) -> Observable<[StandingsEntity]>
}

final class StandingsUseCase: StandingsUseCaseProtocol {
  
  private let footballRepository: FootballRepositoryProtocol
  private let footballRealmRepository: FootballRealmRepositoryProtocol
  
  init(
    footballRepository: FootballRepositoryProtocol,
    footballRealmRepository: FootballRealmRepositoryProtocol
  ) {
    self.footballRepository = footballRepository
    self.footballRealmRepository = footballRealmRepository
  }
  
  func executeRealmStanding(season: Int, league: String) -> Observable<[StandingsEntity]> {
    return footballRealmRepository.standing(season: season, league: league)
      .map {
        return Array($0.content).map {
          StandingsEntity(rank: $0.rank,
                          teamName: $0.teamName,
                          teamLogo: $0.teamLogo,
                          teamID: $0.teamID,
                          played: $0.played,
                          points: $0.points,
                          win: $0.win,
                          draw: $0.draw,
                          lose: $0.lose,
                          goalsDiff: $0.goalsDiff)
        }
      }
      .catch { [weak self] error in
        guard let self = self,
              let error = error as? RealmErrorType
        else { return .error(ScheduleError.realmErrorCastingFail) }
        
        switch error {
        case .emptyData:
          return self.executeStanding(season: season, league: league)
        default:
          print(error)
          return .error(ScheduleError.realmDefaultError)
        }
      }
  }
  
  private func executeStanding(season: Int, league: String) -> Observable<[StandingsEntity]> {
    return footballRepository.standing(season: season, league: league)
      .map {
        let league = $0.response[0].league
        let standings = league.standings[0]
        let standingsEntity = standings.map {
          return StandingsEntity(rank: $0.rank,
                                 teamName: $0.team.name,
                                 teamLogo: $0.team.logo,
                                 teamID: $0.team.id,
                                 played: $0.all.played,
                                 points: $0.points,
                                 win: $0.all.win,
                                 draw: $0.all.draw,
                                 lose: $0.all.lose,
                                 goalsDiff: $0.goalsDiff)
        }
        return standingsEntity
      }
  }
}
