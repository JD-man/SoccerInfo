//
//  MatchDetailSectionModel.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/12/06.
//

import Foundation
import RxDataSources

struct MatchDetailSectionModel: AnimatableSectionModelType {
  
  var identity: Section { return section }
  var section: Section
  var items: [Item]
}

extension MatchDetailSectionModel {
  init(original: MatchDetailSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}

extension MatchDetailSectionModel {
  enum Section: String {
    case event = "기록"
    case formation = "포메이션"
    case startingLineup = "선발 명단"
    case benchLineup = "교체 명단"
  }
  
  enum Item: IdentifiableType, Hashable {
    var identity: String { "\(self.hashValue)"}
    case eventCell(MatchDetailEntity.EventsEntity, Bool)
    case formationCell([MatchDetailEntity.LineupEntity], [MatchDetailEntity.LineupEntity])
    case startingLineupCell(MatchDetailEntity.LineupEntity, MatchDetailEntity.LineupEntity, LeagueInfo)
    case benchLineupCell(MatchDetailEntity.LineupEntity, MatchDetailEntity.LineupEntity, LeagueInfo)
  }
}
