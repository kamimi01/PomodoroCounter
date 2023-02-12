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
    @State private var isShowingCalendar = false
    @State private var isShowingSetting = false

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
                        VStack {
                            CircularProgressbarView(numOfCompletedPomodoro: numOfCompletedPomodoro, numOfTotalPomodoro: numOfTotalPomodoro)
                                .frame(width: 110, height: 110)
                                .padding()
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
                    }
                    addButton
                        .position(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 200)
                    if isShowingCalendar {
                        Color.black
                            .opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                isShowingCalendar = false
                            }
                        calendar
                    }
                }
            }
            .onChange(of: viewModel.selectedDate) { _ in
                viewModel.getTaskList(on: viewModel.selectedDate)
            }
            .navigationTitle(dateString)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    shareButton
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    settingButton
                }
                ToolbarItem(placement: .navigationBarLeading){
                    calendarButton
                }
            }
        }
        .accentColor(.mainText)
    }
}

private extension ContentView {
    var dateString: String {
        let today = Date().convert()
        let selectedDate = viewModel.selectedDate.convert()
        if today == selectedDate {
            return "今日"
        }
        return selectedDate
    }

    var calendar: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.selectedDate = Date()
                }) {
                    Text("今日")
                        .frame(width: 80, height: 40)
                        .foregroundColor(.mainText)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.mainText, lineWidth: 1.0)
                        )
                }
                Spacer()
                Button(action: {
                    isShowingCalendar = false
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.mainText)
                }
            }
            DatePicker(
                "",
                selection: $viewModel.selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .accentColor(.mainGreen)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(Color.white)
        .cornerRadius(20)
    }

    var numOfTotalPomodoro: Int {
        var result = 0
        for task in viewModel.taskList {
            result += task.totalNumOfPomodoro
        }
        return result
    }

    var numOfCompletedPomodoro: Int {
        var result = 0
        for task in viewModel.taskList {
            result += task.completedNumOfPomodoro
        }
        return result
    }

    var addButton: some View {
        Button(action: {
            isShowingAddTaskScreen = true
        }) {
            Image(systemName: "plus")
                .font(.title)
                .frame(width: 90, height: 90)
                .imageScale(.large)
                .background(Color.mainGreen)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
        }
        .fullScreenCover(isPresented: $isShowingAddTaskScreen) {
            AddTaskScreen(selectedDate: viewModel.selectedDate)
        }
    }

    var shareButton: some View {
        ShareLink(item: createDailyReport()) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.mainText)
        }
    }

    var settingButton: some View {
        Button(action: {
            isShowingSetting = true
        }) {
            Image(systemName: "gearshape")
                .foregroundColor(.mainText)
        }
        .fullScreenCover(isPresented: $isShowingSetting) {
            SettingScreen()
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

    var calendarButton: some View {
        Button(action: {
            isShowingCalendar = true
        }) {
            Image(systemName: "calendar")
                .foregroundColor(.mainText)
        }
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
