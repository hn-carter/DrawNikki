//
//  Holiday.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/01/19.
//

import Foundation

struct Holiday {
    
    static let holidayMap: [String:String] = [
        "JP20220101": "元日",
        "JP20220110": "成人の日",
        "JP20220211": "建国記念の日",
        "JP20220223": "天皇誕生日",
        "JP20220321": "春分の日",
        "JP20220426": "昭和の日",
        "JP20220503": "憲法記念日",
        "JP20220504": "みどりの日",
        "JP20220505": "こどもの日",
        "JP20220718": "海の日",
        "JP20220811": "山の日",
        "JP20220919": "敬老の日",
        "JP20220923": "秋分の日",
        "JP20221010": "スポーツの日",
        "JP20221103": "文化の日",
        "JP20221123": "勤労感謝の日"
    ]
    
    // 日付
    static func isHoliday(date: Date, category: String) -> Bool {
        let key = category + date.toShortString()
        if let _ = Holiday.holidayMap[key] {
            return true
        }
        return false
    }
}
