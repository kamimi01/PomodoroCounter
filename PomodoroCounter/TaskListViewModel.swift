//
//  TodoListViewModel.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import Foundation
import RealmSwift

class TaskListViewModel: ObservableObject {
    @Published var taskList: [TaskModel] = [
        TaskModel(id: "1", date: Date(), title: "テレアカの要件定義をする。要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 20, completedNumOfPomodoro: 17, numOfInterruption: 2),
        TaskModel(id: "2", date: Date(), title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 20, completedNumOfPomodoro: 4, numOfInterruption: 2),
        TaskModel(id: "3", date: Date(), title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2)
    ]
    private var token: NotificationToken?
    private var allTasks: Results<Task>? = nil

    init() {
        token = allTasks?.observe { [weak self] _ in
            print("observe呼ばれた")
            guard let self = self,
                  let allTasksNotOptional = self.allTasks
            else {
                return
            }
            self.taskList = Array(allTasksNotOptional).map {
                TaskModel(id: $0.id, date: $0.date, title: $0.title, detail: $0.detail, totalNumOfPomodoro: $0.totalNumOfPomodoro, completedNumOfPomodoro: $0.completedNumOfPomodoro, numOfInterruption: $0.numOfInterruption)
            }
        }
    }
}
