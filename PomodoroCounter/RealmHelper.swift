//
//  RealmHelper.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/29.
//

import Foundation
import RealmSwift

class RealmHelper {
    static let shared = RealmHelper()
    private let realm: Realm

    init() {
        let key = RealmHelper.getKey()
        let config = Realm.Configuration(encryptionKey: key)
        realm = try! Realm()  // まだ暗号化しない
    }

    private static func getKey() -> Data {
        return Data()
    }

    func loadTasks() -> Results<Task> {
        let result = realm.objects(Task.self)
        print("Realmのファイルの場所：", Realm.Configuration.defaultConfiguration.fileURL)
        return result
    }

    func addTask(task: Task) -> Bool {
        do {
            try realm.write {
                realm.add(task)
            }
            return true
        } catch {
            print("追加に失敗しました")
        }
        return false
    }

    func updateTask(
        id: String,
        title: String? = nil,
        detail: String? = nil,
        totalNumOfPomodoro: Int? = nil,
        completedNumOfPomodoro: Int? = nil,
        numOfInterruption: Int? = nil
    ) -> Bool {
        let willUpdateTasks = realm.objects(Task.self).where {
            $0.id == id
        }
        if let willUpdateTask = willUpdateTasks.first {
            do {
                try realm.write {
                    if let newTitle = title {
                        willUpdateTask.title = newTitle
                    }
                    if let newDetail = detail {
                        willUpdateTask.detail = newDetail
                    }
                    if let newTotalNumOfPomodoro = totalNumOfPomodoro {
                        willUpdateTask.totalNumOfPomodoro = newTotalNumOfPomodoro
                    }
                    if let newCompletedNumOfPomodoro = completedNumOfPomodoro {
                        willUpdateTask.completedNumOfPomodoro = newCompletedNumOfPomodoro
                    }
                    if let newNumOfInterruption = numOfInterruption {
                        willUpdateTask.numOfInterruption = newNumOfInterruption
                    }
                }
                return true
            } catch {
                print("更新に失敗しました")
                return false
            }
        } else {
            fatalError("更新対象データが見つかりませんでした")
        }
    }
}
