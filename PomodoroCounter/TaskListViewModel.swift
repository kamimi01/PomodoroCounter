//
//  TodoListViewModel.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import Foundation

class TaskListViewModel: ObservableObject {
    @Published var taskList: [TaskModel] = [
        TaskModel(id: "1", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2),
        TaskModel(id: "2", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2),
        TaskModel(id: "3", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2)
    ]
}
