//
//  TaskCardView.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/28.
//

import SwiftUI

struct TaskCardView: View {
    let task: TaskModel

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 5) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text(String(task.completedNumOfPomodoro))
                        .font(.system(size: 50))
                        .bold()
                        .frame(width: 55)
                    Text("/ " + String(task.totalNumOfPomodoro))
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(width: 50)
                        .padding(.bottom, 10)
                }
                .border(Color.red)
                HStack(alignment: .center, spacing: 3) {
                    Spacer()
                    Text(totalTime(numOfPomodoro: task.completedNumOfPomodoro))
                    HStack(spacing: 3) {
                        Text("(")
                        Image(systemName: "multiply")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                        Text(String(task.numOfInterruption))
                        Text(")")
                    }
                    .font(.system(size: 14))
                    Spacer()
                }
                .foregroundColor(.gray)
            }
            .frame(width: 155)
            .border(Color.red)
            Text(task.title)
                .font(.system(size: 24))
                .foregroundColor(.mainText)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background(task.completedNumOfPomodoro == task.totalNumOfPomodoro ? Color.completedGray : Color.white)
        .cornerRadius(20)
    }
}

private extension TaskCardView {
    func totalTime(numOfPomodoro: Int) -> String {
        let totalMinutes = numOfPomodoro * 30
        let hours = totalMinutes / 60
        let minutes = totalMinutes - hours * 60
        if minutes == 0 {
            return "\(hours)時間"
        }
        return "\(hours)時間\(minutes)分"
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: TaskModel(id: "1", createdDate: Date(), title: "要件定義をする要件定義をする要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 20, completedNumOfPomodoro: 11, numOfInterruption: 10))
    }
}
