//
//  RealmProvider.swift
//  FootballInfo
//
//  Created by 조동현 on 2022/11/29.
//

import Foundation
import RxSwift
import RealmSwift

final class RealmProvider {
  
  func fetchRealmData<T: RealmTable>(query: RealmQuery) -> Observable<T> {
    let app = App(id: APIComponents.realmAppID)
    guard let user = app.currentUser else { return .error(RealmErrorType.loginFail) }
    print("FetchRealmData", user)
    let configuration = user.configuration(partitionValue: query.league)
    
    // Local Realm Load
    print("Local Realm Load")
    guard let localRealm = try? Realm(configuration: configuration) else {
      return .error(RealmErrorType.realmFail)
    }
    
    // check league, season, updateDate
    let objects = localRealm.objects(T.self).where {
      $0._partition == query.league &&
      $0.season == query.season &&
      $0.updateDate > Date()
    }
    
    if objects.isEmpty {
      return asyncCloudRealm(configuration: configuration, query: query)
    }
    else {
      guard let first = objects.first else { return .error(RealmErrorType.realmFail) }
      print("Local Realm loaded")
      return .just(first)
    }
  }
  
  private func asyncCloudRealm<T: RealmTable>(
    configuration: Realm.Configuration,
    query: RealmQuery
  ) -> Observable<T> {
    return .create { observer in
      // Cloud Realm Load
      print("Cloud Realm Load")
      Realm.asyncOpen(configuration: configuration) { result in
        switch result {
        case .success(let realm):
          let syncedObjects = realm.objects(T.self).where {
            $0._partition == query.league &&
            $0.season == query.season &&
            $0.updateDate > Date()
          }
          if syncedObjects.isEmpty {
            observer.onError(RealmErrorType.emptyData)
            print("Cloud Realm Empty")
          }
          else {
            guard let first = syncedObjects.first else {
              return observer.onError(RealmErrorType.realmFail)
            }
            observer.onNext(first)
            observer.onCompleted()
            print("Cloud Realm Loaded")
          }
        case .failure(let error):
          print("sync realm error", error)
          observer.onError(RealmErrorType.realmFail)
        }
      }
      return Disposables.create()
    }
  }
}

extension RealmProvider {
  func updateRealmData<T: RealmTable>(table: T, query: RealmQuery) {
    let app = App(id: APIComponents.realmAppID)
    guard let user = app.currentUser else { return }
    let configuration = user.configuration(partitionValue: query.league)
    
    Realm.asyncOpen(configuration: configuration) { result in
      switch result {
      case .success(let realm):
        do {
          // check league, season
          let object = realm.objects(T.self).where {
            $0._partition == query.league && $0.season == query.season
          }
          
          try realm.write({
            if object.isEmpty {
              realm.add(table)
            }
            else {
              // if both count is not same, content is List Type. Need append
              let prevObject = object.first!
              if prevObject.content.count == table.content.count {
                prevObject.content = table.content
              }
              else {
                prevObject.content.append(table.content.last!)
              }
              
              // Setting New Realm Update Date
              let now = Date()
              let currNewUpdateDate = table.updateDate // 08:00 AM
              let prevUpdateDate = prevObject.updateDate
              
              // same day. prev update date start == newUpdateDate start.
              // update day become nextday 08:00
              
              if prevUpdateDate.dayStart == currNewUpdateDate.dayStart {
                prevObject.updateDate = currNewUpdateDate.nextDay.updateHour
                print("same day")
              }
              // other day now before update day 08:00 AM. now < currNewUpdateDate
              else if now < currNewUpdateDate {
                prevObject.updateDate = currNewUpdateDate
                print("other day before 08:00")
              }
              // other day after 08:00 AM
              else if now >= currNewUpdateDate {
                prevObject.updateDate = currNewUpdateDate.nextDay.updateHour
                print("other day after 08:00")
              }
              print("Realm Upload complete")
            }
          })
        }
        catch {
          print(error)
        }
      case .failure(let error):
        print("sync realm error", error)
      }
    }
  }
}
