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
    @State var isShowingAnimation = true
    @State var isShowingConfirmAlert = false
    @State var isShowingSaveConfirmAlert = false
    @Environment(\.presentationMode) var presentation
    @Environment(\.dismiss) var dismiss
    var columns: [GridItem] = Array(repeating: .init(.fixed(60)), count: 5)

    init(viewModel: TaskListViewModel, task: TaskModel) {
        self.viewModel = viewModel
        self.task = task

        _todoTitle = State(initialValue: self.task.title)
        _todoDetail = State(initialValue: self.task.detail)
        _numOfTotalPomodoroString = State(initialValue: String(self.task.totalNumOfPomodoro))
        _numOfTotalPomodoro = State(initialValue: self.task.totalNumOfPomodoro)
        _numOfCompletedPomodoro = State(initialValue: self.task.completedNumOfPomodoro)
        _numOfInterruption = State(initialValue: self.task.numOfInterruption)
    }

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
                        TextField("資格勉強の本を読む", text: $todoTitle, axis: .vertical)
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
                        TextField("教科書の23ページまで読む", text: $todoDetail, axis: .vertical)
                            .padding()
                            .frame(height : 120.0, alignment: .top)
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
                                    .frame(width: 100, height : 50, alignment: .center)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .focused($isFocusedNum)
                                    .onTapGesture {
                                        isFocusedNum = true
                                    }
                                Button(action: {
                                    // 完了ポモドーロがある場合は、アラート画面でリセットの処理をする
                                    if numOfCompletedPomodoro > 0 {
                                        isShowingConfirmAlert = true
                                        return
                                    }

                                    numOfTotalPomodoro = Int(numOfTotalPomodoroString) ?? 0
                                    // 完了ポモドーロ数をリセットする
                                    numOfCompletedPomodoro = 0
                                }) {
                                    Text("この数に変更する")
                                        .fontWeight(.semibold)
                                        .frame(width: 160, height: 60)
                                        .foregroundColor(.white)
                                        .background(Color.mainText)
                                        .cornerRadius(24)
                                }
                                .alert("確認", isPresented: $isShowingConfirmAlert) {
                                    Button(action: {}) {
                                        Text("キャンセル")
                                    }
                                    Button(action: {
                                        numOfTotalPomodoro = Int(numOfTotalPomodoroString) ?? 0
                                        // 完了ポモドーロ数をリセットする
                                        numOfCompletedPomodoro = 0
                                    }) {
                                        Text("変更する")
                                    }
                                } message: {
                                    Text("変更するとポモドーロの完了数がリセットされます。よろしいですか？")
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)

                        if numOfTotalPomodoro != 0 {
                            VStack {
                                LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                    ForEach((1...numOfTotalPomodoro), id: \.self) { num in
                                        CompletedPomoButton(number: num, numOfCompletedPomodoro: $numOfCompletedPomodoro)
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
                    deleteButton
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            if numOfTotalPomodoro == numOfCompletedPomodoro {
                LottieView(animationType: .confetti, loopMode: .playOnce, isShowingAnimation: $isShowingAnimation)
                    .visibility(hidden: !isShowingAnimation)  // アニメーションを終了したら非表示にする（一度表示し終わると2度目は表示されない）
            }
        }
        .navigationTitle("TODO")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                updateButton
            }
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
}

private extension TaskDetailScreen {
    var backButton: some View {
        Button(action: {
            isShowingSaveConfirmAlert = true
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 17, weight: .medium))
                Text("戻る")
            }
            .foregroundColor(.mainText)
        }
        .alert("確認", isPresented: $isShowingSaveConfirmAlert) {
            Button(action: {}) {
                Text("キャンセル")
            }
            Button(action: {
                dismiss()
            }) {
                Text("戻る")
            }
        } message: {
            Text("完了ボタンは押しましたか？押さずに戻ると入力した内容が破棄されます。")
        }
    }

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

    var updateButton: some View {
        Button(action: {
            let result = viewModel.updateTask(
                id: task.id,
                title: todoTitle,
                detail: todoDetail,
                totalNumOfPomodoro: numOfTotalPomodoro,
                completedNumOfPomodoro: numOfCompletedPomodoro,
                numOfInterruption: numOfInterruption
            )
            if result {
                self.presentation.wrappedValue.dismiss()
            }
        }) {
            Text("完了")
                .foregroundColor(.mainText)
        }
    }

    struct CompletedPomoButton: View {
        @State private var isTapped = false
        let number: Int
        @Binding var numOfCompletedPomodoro: Int

        init(number: Int, numOfCompletedPomodoro: Binding<Int>) {
            self.number = number
            _numOfCompletedPomodoro = numOfCompletedPomodoro
            if number <= numOfCompletedPomodoro.wrappedValue {
                _isTapped = State(initialValue: true)
            } else {
                _isTapped = State(initialValue: false)
            }
        }

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
                        .foregroundColor(.mainGreen)
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

    var deleteButton: some View {
        Button(action: {
            let result = viewModel.deleteTask(id: task.id)
            if result {
                self.presentation.wrappedValue.dismiss()
            }
        }) {
            Text("リストから削除")
                .foregroundColor(.mainText)
                .font(.title3)
                .bold()
        }
        .frame(height: 60)
    }
}

struct TaskDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailScreen(viewModel: TaskListViewModel(), task: TaskModel(id: "1", createdDate: Date(), title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする。xxの要件を明確にし、工数の見積もりができるようにする。", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2))
    }
}
