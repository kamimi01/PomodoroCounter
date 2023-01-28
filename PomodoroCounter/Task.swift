//
//  Task.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/29.
//

import Foundation
import RealmSwift

class Task: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var title = ""
    @objc dynamic var detail = ""
    @objc dynamic var totalNumOfPomodoro = 0
    @objc dynamic var completedNumOfPomodoro = 0
    @objc dynamic var numOfInterruption = 0
}
