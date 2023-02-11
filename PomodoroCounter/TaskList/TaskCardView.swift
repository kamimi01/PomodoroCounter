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
        HStack(alignment: .center, spacing: 5) {
            ZStack {
                Color.timeGreen
                    .frame(width: 148, height: 110)
                    .cornerRadius(20)
                VStack(alignment: .center, spacing: 5) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(String(task.completedNumOfPomodoro))
                            .font(.system(size: 50))
                            .foregroundColor(.mainGreen)
                            .bold()
                            .frame(width: 55)
                        Text("/ " + String(task.totalNumOfPomodoro))
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(width: 50)
                            .padding(.bottom, 10)
                    }
                    HStack(alignment: .center, spacing: 3) {
                        Spacer()
                        Text(totalTime(numOfPomodoro: task.completedNumOfPomodoro))
                        HStack(spacing: 3) {
                            Text("(")
                            Image(systemName: "multiply")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8, height: 8)
                            Text(String(task.numOfInterruption))
                            Text(")")
                        }
                        .font(.system(size: 13))
                        Spacer()
                    }
                    .foregroundColor(.gray)
                }
                .frame(width: 150)
            }
            if task.totalNumOfPomodoro == task.completedNumOfPomodoro {
                Text(task.title)
                    .font(.system(size: 24))
                    .foregroundColor(.mainText)
                    .strikethrough()
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
            } else {
                Text(task.title)
                    .font(.system(size: 24))
                    .foregroundColor(.mainText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 133)
        .background(task.completedNumOfPomodoro == task.totalNumOfPomodoro ? Color.completedGray : Color.white)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 3, x: 3, y: 3)
    }
}

private extension TaskCardView {
    func totalTime(numOfPomodoro: Int) -> String {
        let totalMinutes = numOfPomodoro * 30
        let hours = totalMinutes / 60
        let minutes = totalMinutes - hours * 60
        if hours == 0 {
            return "\(minutes)分"
        }
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
