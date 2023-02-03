//
//  AddTaskViewModel.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    @Published var todoTitle = ""
    @Published var todoDetail = ""
    @Published var numOfTotalPomodoroString = ""

    func addTask(selectedDate: Date) -> Bool {
        let task = Task()
        task.createdDate = selectedDate
        task.title = todoTitle
        task.detail = todoDetail
        task.totalNumOfPomodoro = Int(numOfTotalPomodoroString) ?? 0

        let realmHelper = RealmHelper.shared
        return realmHelper.addTask(task: task)
    }
}
