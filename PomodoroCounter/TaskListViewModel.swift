//
//  TodoListViewModel.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import Foundation

class TaskListViewModel: ObservableObject {
//    @Published var taskList: [TaskModel] = [
//        TaskModel(id: "1", title: "テレアカの要件定義をする。要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 20, completedNumOfPomodoro: 17, numOfInterruption: 2),
//        TaskModel(id: "2", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 20, completedNumOfPomodoro: 4, numOfInterruption: 2),
//        TaskModel(id: "3", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2)
//    ]
    @Published var taskList: [TaskModel] = []
}
