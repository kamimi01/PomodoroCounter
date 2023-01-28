//
//  View+Extension.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/01/29.
//

import SwiftUI

extension View {
   func visibility(hidden: Bool) -> some View {
      modifier(VisibilityStyle(hidden: hidden))
   }
}
