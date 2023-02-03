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
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 10) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text(String(task.completedNumOfPomodoro))
                        .font(.system(size: 90))
                        .bold()
                        .foregroundColor(.mainText)
                        .frame(width: 100)
                    Text("/ " + String(task.totalNumOfPomodoro))
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(width: 55)
                        .padding(.bottom, 15)
                }
                Text(task.title)
                    .font(.system(size: 25))
                    .foregroundColor(.mainText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                Text(totalTime(numOfPomodoro: task.completedNumOfPomodoro) + "分")
                    .font(.title)
                    .foregroundColor(.gray)
                HStack {
                    Text("(")
                        .font(.callout)
                        .foregroundColor(.mainText)
                    Image(systemName: "multiply")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.mainText)
                    Text(String(task.numOfInterruption))
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text(")")
                        .font(.callout)
                        .foregroundColor(.mainText)
                }
                Spacer()
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 170)
        .background(Color.white)
        .cornerRadius(20)
    }
}

private extension TaskCardView {
    func totalTime(numOfPomodoro: Int) -> String {
        return String(numOfPomodoro * 30)
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: TaskModel(id: "1", createdDate: Date(), title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 20, completedNumOfPomodoro: 12, numOfInterruption: 2))
    }
}