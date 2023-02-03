//
//  Date+Extension.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/02/03.
//

import Foundation

extension Date {
    func convert() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
}
