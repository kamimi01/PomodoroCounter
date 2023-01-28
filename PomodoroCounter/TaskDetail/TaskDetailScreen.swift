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
    @State private var todoDetail = ""
    @State private var numOfTotalPomodoroString = ""
    @State private var numOfTotalPomodoro = 0
    @State private var numOfCompletedPomodoro = 0
    @FocusState private var isFocusedTitle: Bool
    @FocusState private var isFocusedDetail: Bool
    @FocusState private var isFocusedNum: Bool

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
                        TextField("お客様が求めているものは何かを明確にする", text: $todoDetail, axis: .vertical)
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
                        VStack(alignment: .leading) {
                            Text("必要なポモドーロ数" + "(\(numOfCompletedPomodoro)/\(numOfTotalPomodoro))")
                                .foregroundColor(.mainText)
                                .padding(.horizontal, 5)
                            HStack(spacing: 20) {
                                TextField("10", text: $numOfTotalPomodoroString, axis: .vertical)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .frame(width: 60, height : 60, alignment: .center)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .focused($isFocusedNum)
                                    .onTapGesture {
                                        isFocusedNum = true
                                    }
                                Button(action: {
                                    numOfTotalPomodoro = Int(numOfTotalPomodoroString) ?? 0
                                    // 完了ポモドーロ数をリセットする
                                    numOfCompletedPomodoro = 0
                                }) {
                                    Text("この数で確定する")
                                        .fontWeight(.semibold)
                                        .frame(width: 160, height: 60)
                                        .foregroundColor(.white)
                                        .background(Color.mainText)
                                        .cornerRadius(24)
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)

                        if numOfTotalPomodoro != 0 {
                            VStack {
                                LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                    ForEach((1...numOfTotalPomodoro), id: \.self) { num in
                                        CompletedPomoButton( numOfCompletedPomodoro: $numOfCompletedPomodoro)
                                    }
                                }
                                Spacer()
                            }

                        }
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        Text("中断した回数" + "(\(numOfInterruption))")
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

    struct CompletedPomoButton: View {
        @State private var isTapped = false
        @Binding var numOfCompletedPomodoro: Int

        var body: some View {
            Button(action: {
                isTapped.toggle()
                if isTapped {
                    numOfCompletedPomodoro += 1
                } else {
                    numOfCompletedPomodoro -= 1
                }
            }) {
                if isTapped {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 60, height: 60)
                } else {
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.mainText)
                        .frame(width: 60, height: 60)
                }
            }
            // 完了ポモドーロ数が0になったら、タップしているかどうかの変数をfalseにリセットする
            .onChange(of: numOfCompletedPomodoro) { value in
                if value == 0 {
                    isTapped = false
                }
            }
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
