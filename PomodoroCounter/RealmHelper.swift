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
}
