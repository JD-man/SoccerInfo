//
//  MatchDetailUseCase.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/06.
//

import Foundation
import RxSwift

protocol MatchDetailUseCaseProtocol: AnyObject {
  typealias EventsEntity = MatchDetailEntity.EventsEntity
  typealias LineupEntity = MatchDetailEntity.LineupEntity
  func executeRealmMatchDetail(season: Int, league: String, fixtureId: Int) -> Observable<MatchDetailEntity>
}

final class MatchDetailUseCase: MatchDetailUseCaseProtocol {
  private let footballRepository: FootballRepositoryProtocol
  private let footballRealmRepository: FootballRealmRepositoryProtocol
  
  init(
    footballRepository: FootballRepositoryProtocol,
    footballRealmRepository: FootballRealmRepositoryProtocol
  ) {
    self.footballRepository = footballRepository
    self.footballRealmRepository = footballRealmRepository
  }
  
  func executeRealmMatchDetail(season: Int, league: String, fixtureId: Int) -> Observable<MatchDetailEntity> {
    return footballRealmRepository.matchDetail(season: season, league: league)
      .compactMap { Array($0.content).filter { $0.fixtureID == fixtureId }.first }
      .map { selectedMatch in
        let fixtureId = selectedMatch.fixtureID
        
        let lineups = [selectedMatch.homeStartLineup, selectedMatch.awayStartLineup, selectedMatch.homeSubLineup,  selectedMatch.awaySubLineup]
          .map { Array($0).map { LineupEntity(name: $0.name, number: $0.number, position: $0.position, grid: $0.grid) } }
        
        let homeStartLineup = lineups[0]
        let awayStartLineup = lineups[1]
        let homeSubLineup = lineups[2]
        let awaySubLineup = lineups[3]
        
        
        let events = Array(selectedMatch.events).map { EventsEntity(time: $0.time, teamName: $0.teamName,
                                                                    player: $0.player, assist: $0.assist,
                                                                    eventType: $0.eventType, eventDetail: $0.eventDetail) }
        
        let homeFormation = selectedMatch.homeFormation
        let awayFormation = selectedMatch.awayFormation
        
        
        return .init(fixtureID: fixtureId,
                     events: events,
                     homeStartLineup: homeStartLineup,
                     homeSubLineup: homeSubLineup,
                     homeFormation: homeFormation,
                     awayStartLineup: awayStartLineup,
                     awaySubLineup: awaySubLineup,
                     awayFormation: awayFormation)
        
      }.catch { [weak self] error in
        guard let self = self,
              let error = error as? RealmErrorType
        else { return .error(ScheduleError.realmErrorCastingFail) }
        switch error {
        case .emptyData:
          return self.executeMatchDetail(fixtureId: fixtureId)
        default:
          return .error(ScheduleError.realmDefaultError)
        }
      }
  }
  
  private func executeMatchDetail(fixtureId: Int) -> Observable<MatchDetailEntity> {
    return .zip(executeEvent(fixtureId: fixtureId), executeLineup(fixtureId: fixtureId)) { eventsAPIData, lineupAPIData in
      let eventResponse = eventsAPIData.response
      let lineupResponse = lineupAPIData.response
      
      // index
      let homeTeam = lineupResponse[0]
      let awayTeam = lineupResponse[1]
      
      let fixtureId = fixtureId
      
      let startLineups = [homeTeam.startXI, awayTeam.startXI].map { $0.map { $0.player} }
      let subLineups = [homeTeam.substitutes, awayTeam.substitutes].map { $0.map { $0.player} }
      let lineups = [startLineups, subLineups].flatMap { $0.map { $0.map { LineupEntity(name: $0.name, number: $0.number, position: $0.pos, grid: $0.grid) } } }
      
      let homeStartLineup = lineups[0]
      let awayStartLineup = lineups[1]
      let homeSubLineup = lineups[2]
      let awaySubLineup = lineups[3]
      
      let homeFormation = homeTeam.formation
      let awayFormation = awayTeam.formation
      let homeStartId = homeTeam.startXI.map { $0.player.id }
      let awayStartId = awayTeam.startXI.map { $0.player.id }
      let events = eventResponse
        .map {
          if $0.type == "subst" {
            let inId = $0.player.id ?? -1
            let outId = $0.assist.id ?? -2
            if homeStartId.contains(outId) || awayStartId.contains(outId) {
              return $0
            }
            else {
              let newPlayer = EventsPlayer(id: outId, name: $0.assist.name ?? "")
              let newAssist = EventsAssist(id: inId, name: $0.player.name)
              return EventsResponse(time: $0.time,
                                    team: $0.team,
                                    player: newPlayer,
                                    assist: newAssist,
                                    type: $0.type,
                                    detail: $0.detail)
            }
          }
          else {
            return $0
          }
        }
        .map {
          EventsEntity(time: $0.time.elapsed + ($0.time.extra ?? 0),
                       teamName: $0.team.name,
                       player: $0.player.name,
                       assist: $0.assist.name,
                       eventType: $0.type,
                       eventDetail: $0.detail)
        }
      
      let matchDetailEntity = MatchDetailEntity(fixtureID: fixtureId,
                                                events: events,
                                                homeStartLineup: homeStartLineup,
                                                homeSubLineup: homeSubLineup,
                                                homeFormation: homeFormation,
                                                awayStartLineup: awayStartLineup,
                                                awaySubLineup: awaySubLineup,
                                                awayFormation: awayFormation)
      
      
      return matchDetailEntity
    }
  }
  
  private func executeEvent(fixtureId: Int) -> Observable<EventsAPIData> {
    return footballRepository.event(fixtureId: "\(fixtureId)")
  }
  
  private func executeLineup(fixtureId: Int) -> Observable<LineupsAPIData> {
    return footballRepository.lineup(fixtureId: "\(fixtureId)")
  }
}
