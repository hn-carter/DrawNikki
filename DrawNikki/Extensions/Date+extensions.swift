//
//  Date+extensions.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/25.
//

import Foundation
import os

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
    
    public func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: self)
    }
    
    public func toShortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
    
    public func removeTimeStamp(calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        guard let date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self)) else {
            // 失敗した場合はそのまま返す
            return self
        }
        return date
    }
    
    public func getYear(calendar: Calendar = Calendar(identifier: .gregorian)) -> Int {
        let components = calendar.dateComponents([.year], from: self)
        return components.year!
    }
    
    public func getMonth(calendar: Calendar = Calendar(identifier: .gregorian)) -> Int {
        let components = calendar.dateComponents([.month], from: self)
        return components.month!
    }
    
    public func getDay(calendar: Calendar = Calendar(identifier: .gregorian)) -> Int {
        let components = calendar.dateComponents([.day], from: self)
        return components.day!
    }
}
