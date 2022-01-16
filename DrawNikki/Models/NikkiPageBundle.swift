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
    
    // 現在見ているtodayPagesのインデックス (初期値無効)
    private var currentIndex: Int = -1
    
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
        let n = yesterdayPages.count
        logger.debug("yesterday: \(n)")
        // 今日
        self.todayPages = loadNikkiPagesByDate(date: date)
        let t = todayPages.count
        if t > 0 {
            currentIndex = 0
        } else {
            currentIndex = -1
        }
        logger.debug("today: \(t)")
        // 明日
        let tomorrow = Constants.dbCalendar.date(byAdding: .day, value: 1, to: date)!
        self.tomorrowPages = loadNikkiPagesByDate(date: tomorrow)
        let m = tomorrowPages.count
        logger.debug("tomorrow: \(m)")
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
        for r in records {
            logger.debug("CoreData date: \(r.date!.toString()), number: \(r.number), picture_filename: \(r.picture_filename!), text_filename: \(r.text_filename!), created_at: \(r.created_at!.toString()), updated_at: \(r.updated_at!.toString())")
        }
        
        let pages = records.map{
            NikkiPage(nikkiRec: $0, controller: pController)
        }
        return pages
    }
    
    
    /// 今日の日記ページを再読み込みする
    mutating func reloadNikkiPagesByToday() {
        guard let date = self.today else { return }
        self.todayPages = loadNikkiPagesByDate(date: date)
        let t = todayPages.count
        // この日の最初のページの場合は現在参照ページ番号を設定する
        // すでにページがある場合は見ているページ位置を更新したくないため何もしない
        if t == 1 && currentIndex == -1 {
            currentIndex = 0
        }
        logger.debug("reload today pages: \(t)")
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
    
    /// 前のページを返す
    /// - Returns: 前ページ
    mutating func getPreviousPage() -> NikkiPage {
        logger.trace("NikkiPageBundle.getPreviousPage")
        if currentIndex == 0 {
            // 前日
            today = Calendar.current.date(byAdding: .day, value: -1, to: today!)!
            tomorrowPages = todayPages
            todayPages = yesterdayPages
            // 前日ページを取得する
            yesterdayPages = loadNikkiPagesByDate(date: today!)
            if todayPages.count == 0 {
                // 今日のページがない場合は空ページを返す
                return NikkiPage(date: today!, number: 0, controller: pController)
            } else {
                currentIndex = todayPages.count - 1
                return todayPages[currentIndex]
            }
        }
        // 今日
        currentIndex -= 1
        return todayPages[currentIndex]
    }

    
    /// 次のページを返す
    /// - Returns: 次ページ
    mutating func getNextPage() -> NikkiPage {
        logger.trace("NikkiPageBundle.getNextPage")
        if currentIndex >= (todayPages.count - 1) {
            // 翌日
            today = Calendar.current.date(byAdding: .day, value: 1, to: today!)!
            yesterdayPages = todayPages
            todayPages = tomorrowPages
            // 翌日ページを取得する
            tomorrowPages = loadNikkiPagesByDate(date: today!)
            if todayPages.count == 0 {
                // 今日のページがない場合は空ページを返す
                return NikkiPage(date: today!, number: 0, controller: pController)
            } else {
                currentIndex = 0
                return todayPages[currentIndex]
            }
        }
        // 今日
        currentIndex += 1
        return todayPages[currentIndex]
    }
    
    
    mutating func addPage(page: inout NikkiPage) -> Bool {
        logger.trace("NikkiPageBundle.addPage")
        // ページの追加
        let ret = page.addNikkiPage()
        if !ret {
            logger.error("ページの新規保存に失敗 pageModel.addNikkiPage()")
            return false
        }
        // 今日の全ページを再取得
        todayPages = loadNikkiPagesByDate(date: today!)
        // 最終ページ
        currentIndex = page.number - 1
        return true
    }
    
    mutating func updatePage(page: inout NikkiPage) -> Bool {
        logger.trace("NikkiPageBundle.updatePage")

        let ret = page.updateNikkiPage()
        if !ret == false {
            logger.error("ページの上書き更新に失敗 pageModel.updateNikkiPage()")
            return false
        }
        // 今日の全ページを再取得
        todayPages = loadNikkiPagesByDate(date: today!)
        return true
    }
    
    
    /// 現在のページを削除
    /// - Returns: 処理結果 true: 正常
    mutating func deletePage() -> Bool {
        logger.trace("NikkiPageBundle.deletePage")
        
        if currentIndex >= todayPages.count {
            // 元からこのページは存在しない
            return true
        }
        
        let ret = todayPages[currentIndex].deleteNikkiPage()
        if ret == false {
            logger.error("ページの削除に失敗 pageModel.deleteNikkiPage()")
            return false
        }
        // 今日の全ページを再取得
        todayPages = loadNikkiPagesByDate(date: today!)

        return false
    }
    
    
}
