//
//  LottieView.swift
//  JapanTravelRoulette
//
//  Created by mikaurakawa on 2023/01/16.
//

import SwiftUI
import Lottie

enum AnimationType: String {
    case emptyTask = "empty_task"
    case confetti = "confetti"
}

struct LottieView: UIViewRepresentable {
    let animationType: AnimationType
    let loopMode: LottieLoopMode
    @Binding var isShowingAnimation: Bool

    init(animationType: AnimationType, loopMode: LottieLoopMode, isShowingAnimation: Binding<Bool> = .constant(true)) {
        self.animationType = animationType
        self.loopMode = loopMode
        _isShowingAnimation = isShowingAnimation
    }

    func makeUIView(context: Context) -> UIView {
        let view = LottieAnimationView(name: animationType.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false

        let parentView = UIView()
        parentView.addSubview(view)
        parentView.addConstraints([
            view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: parentView.heightAnchor)
        ])

        view.play { finished in
            if finished {
                isShowingAnimation = false
            }
        }
        view.loopMode = loopMode

        return parentView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
