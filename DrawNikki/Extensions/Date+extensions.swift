//
//  Date+extensions.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/25.
//

import Foundation

extension Date {

    /// Date生成
    /// - Parameters:
    ///   - calendar: 値の意味を特定するカレンダー
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 時
    ///   - minute: 分
    ///   - second: 秒
    init(calendar: Calendar = Calendar(identifier: .gregorian), year: Int, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        let comp = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        let date: Date = comp.date!
        self.init(timeInterval:0, since:date)
    }
}
