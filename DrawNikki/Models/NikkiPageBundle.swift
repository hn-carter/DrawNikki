//
//  NikkiPageBundle.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/10.
//

import Foundation
import os

struct NikkiPageBundle {
    private let logger = Logger(subsystem: "DrawNikki.NikkiPageBundle", category: "NikkiPageBundle")

    
    private var yesterdayPages: [NikkiPage] = []
    
    private var today: Date?
    
    private var todayPages: [NikkiPage] = []
    
    private var currentIndex: Int = 0
    
    private var tomorrowPages: [NikkiPage] = []
    
    private var pController: PersistenceController
    
    private var fileNumberDB: FileNumberRepository

    private var nikkiDB: NikkiRepository

    init(controller: PersistenceController) {
        self.pController = controller
        self.fileNumberDB = FileNumberRepository(controller: controller)
        self.nikkiDB = NikkiRepository(controller: controller)
    }
    
    
    /// 今日と前後の日記ページを取得する
    /// - Parameters:
    ///   - calendar: カレンダー
    ///   - date: 今日の日付
    mutating func loadNikkiPagesByYesterdayTodayTomorrow(date: Date) {
        self.today = date
        // 前日
        let yesterday = Constants.dbCalendar.date(byAdding: .day, value: -1, to: date)!
        self.yesterdayPages = loadNikkiPagesByDate(date: yesterday)
        // 今日
        self.todayPages = loadNikkiPagesByDate(date: date)
        // 明日
        let tomorrow = Constants.dbCalendar.date(byAdding: .day, value: 1, to: date)!
        self.tomorrowPages = loadNikkiPagesByDate(date: tomorrow)
    }
    
    /// 指定日の日記ベージを取得する
    /// - Parameters:
    ///   - date: 日付
    /// - Returns: 日記ページ配列
    func loadNikkiPagesByDate(date: Date) -> [NikkiPage] {
        // 指定日のページを取得
        let records: [NikkiRecord] = nikkiDB.getNikkiOnDay(date: date)
        // 表示形式に変換
        if records.count == 0 {
            return []
        }
        let pages = records.map{
            NikkiPage(nikkiRec: $0, controller: pController)
        }
        return pages
    }
    
    /// 表示中、処理中のページを返す
    /// 該当ページがない場合は空（初期）状態のページを返す
    /// - Returns: ページ
    func getCurrentPage() -> NikkiPage {
        if todayPages.count == 0 {
            // 今日のページがない場合は空ページを返す
            return NikkiPage(date: today!, number: 0, controller: pController)
        }
        // 対象ページ
        return todayPages[currentIndex]
    }
    
    var existsPreviousPage: Bool {
        return false
    }
    
    /*
    func getPreviousPage() -> NikkiPage {

    }
    
    var existsNextPage: Bool {
        return false
    }
    
    func getNextPage() -> NikkiPage {
        
    }
     */
}
