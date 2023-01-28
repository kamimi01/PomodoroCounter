//
//  VisibilityStyle.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/29.
//

import SwiftUI

struct VisibilityStyle: ViewModifier {
    let hidden: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if hidden {
            content.hidden()
        } else {
            content
        }
    }
}
