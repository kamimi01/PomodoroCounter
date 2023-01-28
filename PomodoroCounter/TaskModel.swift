//
//  TaskModel.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import Foundation

struct TaskModel: Hashable {
    let id: String
    let date: Date
    let title: String
    let detail: String
    let totalNumOfPomodoro: Int
    let completedNumOfPomodoro: Int
    let numOfInterruption: Int
}
