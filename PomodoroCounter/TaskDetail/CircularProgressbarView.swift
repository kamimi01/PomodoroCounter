//
//  CircularProgressbarView.swift
//  JapanTravelRoulette
//
//  Created by mikaurakawa on 2023/02/02.
//

import SwiftUI

struct CircularProgressbarView: View {
    let numOfCompletedPomodoro: Int
    let numOfTotalPomodoro: Int

    var body: some View {
        ZStack {
            // 背景の円
            Circle()
            // ボーダーラインを描画するように指定
                .stroke(lineWidth: 12.0)
                .opacity(0.3)
                .foregroundColor(.mainGreen)

            // 進捗を示す円
            Circle()
            // 始点/終点を指定して円を描画する
            // 始点/終点には0.0-1.0の範囲に正規化した値を指定する
                .trim(from: 0.0, to: min(CGFloat(Double(numOfCompletedPomodoro) / Double(numOfTotalPomodoro)), 1.0))
            // 線の端の形状などを指定
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .foregroundColor(.mainGreen)
            // デフォルトの原点は時計の12時の位置ではないので回転させる
                .rotationEffect(Angle(degrees: 270.0))

            // 進捗率のテキスト
            HStack {
                Text(String(numOfCompletedPomodoro))
                    .foregroundColor(.mainGreen)
                    .font(.largeTitle)
                    .bold()
                Text("/ \(numOfTotalPomodoro)")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CircularProgressbarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressbarView(numOfCompletedPomodoro: 10, numOfTotalPomodoro: 20)
    }
}
