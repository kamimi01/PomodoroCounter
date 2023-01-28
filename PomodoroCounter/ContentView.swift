//
//  ContentView.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = TaskListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackground
                    .edgesIgnoringSafeArea(.all)
                if viewModel.taskList.isEmpty {
                    LottieView(animationType: .emptyTask)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.taskList, id: \.self) { task in
                                NavigationLink(destination: TaskDetailScreen(viewModel: viewModel, task: task)) {
                                    TaskCardView(task: task)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("今日のTODOリスト")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
