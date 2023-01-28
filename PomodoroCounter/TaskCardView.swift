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
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 20) {
                HStack(alignment: .bottom, spacing: 10) {
                    Text(String(task.completedNumOfPomodoro))
                        .font(.system(size: 90))
                        .bold()
                        .foregroundColor(.mainText)
                    Text("pomo")
                        .font(.title2)
                        .foregroundColor(.mainText)
                        .padding(.bottom, 20)
                }
                Text(task.title)
                    .font(.title)
                    .foregroundColor(.mainText)
                    .lineLimit(2)
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
                        .foregroundColor(.red)
                    Text(String(task.numOfInterruption))
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text(")")
                        .font(.callout)
                        .foregroundColor(.mainText)
                }
            }
        }
        .padding()
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
        TaskCardView(task: TaskModel(id: "1", title: "要件定義をする", detail: "xxの要件を明確にし、工数の見積もりができるようにする", totalNumOfPomodoro: 10, completedNumOfPomodoro: 4, numOfInterruption: 2))
    }
}
