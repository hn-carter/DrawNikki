//
//  Constants.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/22.
//

import Foundation

struct Constants {
    // 保存に使用するカレンダー
    static let dbCalendar: Calendar = Calendar(identifier: .gregorian)
    
    // 日記文章の表示行数
    static let maxTextLine: Int = 10
    // 日記文章の最大文字数
    static let maxTextCount: Int = 400
}
