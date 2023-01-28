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

    @State private var todoTitle = ""
    @FocusState private var isFocusedTitle: Bool
    @FocusState private var isFocusedDetail: Bool

    @State private var numOfTotalPomodoro = 0
    @State private var numOfInterruption = 0
    var columns: [GridItem] = Array(repeating: .init(.fixed(60)), count: 5)

    var body: some View {
        ZStack {
            Color.mainBackground
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("タイトル")
                            .foregroundColor(.mainText)
                            .padding(.horizontal, 5)
                        TextField("ABC会社の資料作成", text: $todoTitle, axis: .vertical)
                            .padding()
                            .frame(height : 50.0, alignment: .top)
                            .background(Color.white)
                            .cornerRadius(20)
                            .focused($isFocusedTitle)
                            .onTapGesture {
                                isFocusedTitle = true
                            }
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("詳細")
                            .foregroundColor(.mainText)
                            .padding(.horizontal, 5)
                        TextField("お客様が求めているものは何かを明確にする", text: $todoTitle, axis: .vertical)
                            .padding()
                            .frame(height : 110.0, alignment: .top)
                            .background(Color.white)
                            .cornerRadius(20)
                            .focused($isFocusedDetail)
                            .onTapGesture {
                                isFocusedDetail = true
                            }
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        Text("必要なポモドーロ数")
                            .foregroundColor(.mainText)
                            .padding(.horizontal, 5)
                        HStack(spacing: 30) {
                            Spacer()
                            addPomoButton
                            deletePomoButton
                            Spacer()
                        }

                        ZStack {
                            VStack {
                                LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                    ForEach((1...10), id: \.self) { num in
                                        completedPlaceHoler
                                    }
                                }
                                Spacer()
                            }
                            if numOfTotalPomodoro != 0 {
                                VStack {
                                    LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                        ForEach((1...numOfTotalPomodoro), id: \.self) { num in
                                            completedButton
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        Text("中断した回数")
                            .foregroundColor(.mainText)
                            .padding(.horizontal, 5)
                        HStack(spacing: 30) {
                            Spacer()
                            addInterruptionButton
                            deleteInterruptionButton
                            Spacer()
                        }

                        ZStack {
                            VStack {
                                LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                    ForEach((1...5), id: \.self) { num in
                                        interruptionPlaceHoler
                                    }
                                }
                                Spacer()
                            }
                            if numOfInterruption != 0 {
                                VStack {
                                    LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                        ForEach((1...numOfInterruption), id: \.self) { num in
                                            interruptionHappen
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("TODO")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension TaskDetailScreen {
    var addPomoButton: some View {
        Button(action: {
            numOfTotalPomodoro += 1
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
        }
        .background(Color.mainText)
        .cornerRadius(50)
    }

    var deletePomoButton: some View {
        Button(action: {
            if numOfTotalPomodoro != 0 {
                numOfTotalPomodoro -= 1
            }
        }) {
            Image(systemName: "minus")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
        }
        .background(Color.mainText)
        .cornerRadius(50)
    }

    var completedButton: some View {
        Button(action: {}) {
            Image(systemName: "checkmark.square")
                .resizable()
                .scaledToFit()
                .foregroundColor(.mainText)
                .frame(width: 60, height: 60)
        }
    }

    var completedPlaceHoler: some View {
        Image(systemName: "checkmark.square")
            .resizable()
            .scaledToFit()
            .foregroundColor(.placeholder)
            .frame(width: 60, height: 60)
    }

    var addInterruptionButton: some View {
        Button(action: {
            numOfInterruption += 1
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
        }
        .background(Color.mainText)
        .cornerRadius(50)
    }

    var deleteInterruptionButton: some View {
        Button(action: {
            if numOfInterruption != 0 {
                numOfInterruption -= 1
            }
        }) {
            Image(systemName: "minus")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
        }
        .background(Color.mainText)
        .cornerRadius(50)
    }

    var interruptionHappen: some View {
        Image(systemName: "multiply")
            .resizable()
            .scaledToFit()
            .foregroundColor(.mainText)
            .frame(width: 50, height: 50)
    }

    var interruptionPlaceHoler: some View {
        Image(systemName: "multiply")
            .resizable()
            .scaledToFit()
            .foregroundColor(.placeholder)
            .frame(width: 50, height: 50)
    }
}

struct TaskDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailScreen(viewModel: TaskListViewModel(), task: TaskModel(id: "1", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2))
    }
}
