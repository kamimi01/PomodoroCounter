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
        print("key:", key.map { String(format: "%.2hhx", $0) }.joined())
        let config = Realm.Configuration(encryptionKey: key)
        realm = try! Realm(configuration: config)
    }

    // あれば既存の暗号化キーを取得する。なければ新しく作成する
    private static func getKey() -> Data {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // 既存のキーがあるか確認する
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        // Swiftの最適化のバグを避けるため、withUnsafeMutablePointer() を使って、キーチェーンからitemを取り出す
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }

        // 事前に作成されたキーがない場合、新しく生成する
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })

        // キーチェーンにキーを保存する
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")

        return key
    }

    func loadTasks() -> Results<Task> {
        let result = realm.objects(Task.self)
        print("Realmのファイルの場所：", Realm.Configuration.defaultConfiguration.fileURL)
        return result
    }

    func loadTasks(with date: Date) -> [Task] {
        let allTasks = loadTasks()
        let dateString = date.convert()
        var tasks: [Task] = []
        for task in allTasks {
            let taskDateString = task.createdDate.convert()
            if taskDateString == dateString {
                tasks.append(task)
            }
        }
        return tasks
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

    func deleteTask(id: String) -> Bool {
        let willDeleteTasks = realm.objects(Task.self).where {
            $0.id == id
        }
        if let willDeleteTask = willDeleteTasks.first {
            do {
                try realm.write {
                    realm.delete(willDeleteTask)
                }
                return true
            } catch {
                print("削除に失敗しました")
                return false
            }
        } else {
            fatalError("削除対象が見つかりませんでした")
        }
    }

    func deleteAllTasks() -> Bool {
        let allTasks = realm.objects(Task.self)
        do {
            try realm.write {
                realm.delete(allTasks)
            }
            return true
        } catch {
            print("削除に失敗しました")
            return false
        }
    }
}
