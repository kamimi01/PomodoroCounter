//
//  ContentView.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = TaskListViewModel()
    @State private var isShowingAddTaskScreen = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackground
                    .edgesIgnoringSafeArea(.all)
                if viewModel.taskList.isEmpty {
                    LottieView(animationType: .emptyTask)
                } else {
                    ZStack {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.taskList, id: \.self) { task in
                                    NavigationLink(destination: TaskDetailScreen(viewModel: viewModel, task: task)) {
                                        TaskCardView(task: task)
                                            .padding(.horizontal, 16)
                                    }
                                }
                                Color.mainBackground
                                    .frame(height: 185)
                            }
                        }
                        addButton
                            .position(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 270)
                    }
                }
            }
            .navigationTitle("今日のTODOリスト")
        }
    }
}

private extension ContentView {
    var addButton: some View {
        Button(action: {
            isShowingAddTaskScreen = true
        }) {
            Image(systemName: "plus")
                .font(.title)
                .frame(width: 90, height: 90)
                .imageScale(.large)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
        }
        .fullScreenCover(isPresented: $isShowingAddTaskScreen) {
            AddTaskScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
