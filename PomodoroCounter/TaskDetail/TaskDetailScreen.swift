//
//  TaskDetailScreen.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import SwiftUI

struct TaskDetailScreen: View {
    @ObservedObject var viewModel: TaskListViewModel
    let task: TaskModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TaskDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailScreen(viewModel: TaskListViewModel(), task: TaskModel(id: "1", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2))
    }
}
