//
//  DateFormatter+extension.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/01/21.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
