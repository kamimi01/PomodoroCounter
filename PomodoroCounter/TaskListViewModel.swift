//
//  TodoListViewModel.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import Foundation
import RealmSwift

class TaskListViewModel: ObservableObject {
    @Published var taskList: [TaskModel] = []
    @Published var selectedDate = Date()
    private let realmHelper: RealmHelper
    private var token: NotificationToken?
    private var allTasks: Results<Task>? = nil

    init() {
        realmHelper = RealmHelper.shared
        allTasks = realmHelper.loadTasks()
        token = allTasks?.observe { [weak self] _ in
            print("observe呼ばれた")
            guard let self = self,
                  let allTasksNotOptional = self.allTasks
            else {
                return
            }
            self.taskList = Array(allTasksNotOptional).map {
                TaskModel(id: $0.id, createdDate: $0.createdDate, title: $0.title, detail: $0.detail, totalNumOfPomodoro: $0.totalNumOfPomodoro, completedNumOfPomodoro: $0.completedNumOfPomodoro, numOfInterruption: $0.numOfInterruption)
            }.filter {
                let selectedDateString = self.selectedDate.convert()
                let taskDateString = $0.createdDate.convert()
                return selectedDateString == taskDateString
            }
        }
    }

    func getTaskList(on date: Date) {
        print("選択されたdate:", date)
        let tasks = realmHelper.loadTasks(with: date)
        taskList = tasks.map {
            TaskModel(id: $0.id, createdDate: $0.createdDate, title: $0.title, detail: $0.detail, totalNumOfPomodoro: $0.totalNumOfPomodoro, completedNumOfPomodoro: $0.completedNumOfPomodoro, numOfInterruption: $0.numOfInterruption)
        }
    }

    func updateTask(
        id: String,
        title: String? = nil,
        detail: String? = nil,
        totalNumOfPomodoro: Int? = nil,
        completedNumOfPomodoro: Int? = nil,
        numOfInterruption: Int? = nil
    ) -> Bool {
        return realmHelper.updateTask(
            id: id,
            title: title,
            detail: detail,
            totalNumOfPomodoro: totalNumOfPomodoro,
            completedNumOfPomodoro: completedNumOfPomodoro,
            numOfInterruption: numOfInterruption
        )
    }

    func deleteTask(id: String) -> Bool {
        return realmHelper.deleteTask(id: id)
    }

    func deleteAllTasks() -> Bool {
        return realmHelper.deleteAllTasks()
    }
}
