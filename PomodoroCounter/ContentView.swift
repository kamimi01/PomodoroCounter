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
    @State private var isShowingResetAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackground
                    .edgesIgnoringSafeArea(.all)
                ZStack {
                    if viewModel.taskList.isEmpty {
                        LottieView(animationType: .emptyTask, loopMode: .loop)
                            .frame(width: 300, height: 400)
                    } else {
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
                    }
                    addButton
                        .position(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 270)
                }
            }
            .navigationTitle("今日のTODOリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    shareButton
                }
                ToolbarItem(placement: .navigationBarLeading){
                    resetButton
                }
            }
        }
        .accentColor(.mainText)
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
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
        }
        .fullScreenCover(isPresented: $isShowingAddTaskScreen) {
            AddTaskScreen()
        }
    }

    var shareButton: some View {
        ShareLink(item: createDailyReport()) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.mainText)
        }
    }

    func createDailyReport() -> String {
        var sharedText = ""
        for todo in viewModel.taskList {
            let totalPomodoroDuration = todo.totalNumOfPomodoro * 30
            let completedPomodoroDuration = todo.completedNumOfPomodoro * 30
            sharedText += """
            - [\(completedPomodoroDuration)分(\(todo.completedNumOfPomodoro))/\(totalPomodoroDuration)分(\(todo.totalNumOfPomodoro))] \(todo.title)(\(todo.detail))\n
            """
        }
        return sharedText
    }

    var resetButton: some View {
        Button(action: {
            isShowingResetAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(.mainText)
        }
        .alert("確認", isPresented: $isShowingResetAlert) {
            Button(action: {}) {
                Text("キャンセル")
            }
            Button(action: {
                _ = viewModel.deleteAllTasks()
            }) {
                Text("削除")
            }
        } message: {
            Text("今日のTODOを全て削除します。よろしいですか？\n右上の共有ボタンからデータを出力することができます。")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
