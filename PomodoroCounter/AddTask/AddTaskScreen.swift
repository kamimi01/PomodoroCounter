//
//  AddTaskScreen.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import SwiftUI

struct AddTaskScreen: View {
    @ObservedObject var viewModel = AddTaskViewModel()

//    @State private var todoTitle = ""
//    @State private var todoDetail = ""
//    @State private var numOfTotalPomodoroString = ""
//    @State private var numOfTotalPomodoro = 0
    @FocusState private var isFocusedTitle: Bool
    @FocusState private var isFocusedDetail: Bool
    @FocusState private var isFocusedNum: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackground
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("タイトル")
                                .foregroundColor(.mainText)
                                .padding(.horizontal, 5)
                            TextField("資格勉強の本を読む", text: $viewModel.todoTitle, axis: .vertical)
                                .padding()
                                .frame(height : 55.0, alignment: .top)
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
                            TextField("教科書の23ページまで読む", text: $viewModel.todoDetail, axis: .vertical)
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
                                Text("必要なポモドーロ数")
                                    .foregroundColor(.mainText)
                                    .padding(.horizontal, 5)
                                HStack(spacing: 20) {
                                    TextField("10", text: $viewModel.numOfTotalPomodoroString, axis: .vertical)
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .frame(width: 100, height : 60, alignment: .center)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .focused($isFocusedNum)
                                        .onTapGesture {
                                            isFocusedNum = true
                                        }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("新しいTODO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    dismissButton
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    addButton
                }
            }
        }
        .accentColor(.mainText)
    }
}

private extension AddTaskScreen {
    var dismissButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "multiply")
                .foregroundColor(.mainText)
        }
    }

    var addButton: some View {
        Button(action: {
            let result = viewModel.addTask()
            if result {
                dismiss()
            }
        }) {
            Text("追加")
                .foregroundColor(.mainText)
        }
    }
}

struct AddTaskScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskScreen()
    }
}
