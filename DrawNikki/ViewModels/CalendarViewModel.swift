//
//  CalendarViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/01/17.
//

import Foundation
import os

/// カレンダーのViewModel
class CalendarViewModel: ObservableObject {
    let logger = Logger(subsystem: "DrawNikki.CalendarViewModel", category: "CalendarViewModel")

    let cdController: PersistenceController

    // 日記ページデータ Model
    var nikkiPagesModel: NikkiPageBundle

    /// プレビュー用
    init() {
        self.cdController = PersistenceController()
        self.nikkiPagesModel = NikkiPageBundle(controller: self.cdController)
    }
    
    /// 年月を指定してページを取得する
    /// - Parameters:
    ///   - calendar: カレンダー
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 結果ページ配列
    func getCalendarData(calendar: Calendar, year: Int, month: Int) -> [NikkiPage] {
        let pagesInMonth = nikkiPagesModel.getNikkiInMonth(calendar: calendar, year: year, month: month)
        
        return pagesInMonth
    }

    func createEmptyPage(date: Date) -> NikkiPage {
        return NikkiPage(date: date, controller: cdController)
    }
}
