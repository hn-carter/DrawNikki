//
//  NikkiViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/25.
//

import Foundation
import SwiftUI
import CoreData
import os


/// 絵日記ViewModel
class NikkiViewModel: ObservableObject {
    // アプリ設定値
    var conf: NikkiManager = NikkiManager()
    // 日記カレンダー
    //@Published var calendarVM: CalendarViewModel?
    // 日記ページ
    @Published var pageVM: PageViewModel?
    
    @Published var fnumber: Int = 0
    
    @Published var updateItem : File_number! = nil

    let logger = Logger(subsystem: "DrawNikki.NikkiViewModel", category: "NikkiViewModel")
    let cdController: PersistenceController
    // 最後に使用したファイル番号
    var fileNumber: Int = 0
    // 日記ページデータ
    var nikkiPages: NikkiPageBundle
    
    init() {
        self.cdController = PersistenceController()
        self.nikkiPages = NikkiPageBundle(controller: self.cdController)
        // 日記データ初期読み込み
        load()
        setTodayPage()
    }
    
    func initialize() {
        
    }
    
    
    /// ファイルの番号を取得する
    func readFileNumber() {
        // ファイルの管理番号を取得
        let fileNumberDB = FileNumberRepository(controller: cdController)
        if let fileNumberRec = fileNumberDB.getFileNumber() {
            fileNumber = fileNumberRec.fileNumber
        } else {
            // ファイルの番号が取得できなかった場合は0で新規作成する
            logger.info("File_number is nil")
            // ファイルの管理番号を初期化
            var newItem = FileNumberRecord(fileNumber: 0)
            newItem.created_at = Date()
            newItem.updated_at = Date()
            fileNumberDB.createFileNumber(item: newItem)

            fileNumber = 0
        }
    }
    
    
    func loadNikkiInMonth(year: Int, month: Int) {
        
    }

    func writeData(context : NSManagedObjectContext) {
        if updateItem != nil{
            // データ更新
            updateItem.number = Int32(fnumber)
            updateItem.created_at = Date()
            updateItem.updated_at = Date()
            // 保存
            try! context.save()
            
            fnumber += 1
            return
        }
        // データ新規登録
        let newFileNumber = File_number(context: context)
        newFileNumber.number = Int32(fnumber)
        newFileNumber.created_at = Date()
        newFileNumber.updated_at = Date()

        do{
            try context.save()
            fnumber += 1
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func getAllData() {
        let file_num: File_number = File_number()
        var fileNum: [File_number]
        fileNum = file_num.getAllData()
        fileNum.forEach {
            self.fnumber = Int($0.number)
        }
        
    }
    
    /// 今日の日付でPageViewModelを作成する
    /// 今日の日記がない場合は白紙ページとする
    func setTodayPage() {
        logger.info("NikkiViewModel.setTodayPage")
        let page = nikkiPages.getCurrentPage()
        pageVM = PageViewModel(bundle: nikkiPages, page: page)
    }

    /// 日記データを読み込む
    func load() {
        logger.trace("NikkiViewModel.load")
        
        // 全削除 (●テスト用)
        //File_number.deleteAllData(context: self.cdController.container.viewContext)
        //Nikki.deleteAllData(context: self.cdController.container.viewContext)
        // 全削除 (●テスト用)
        
        // ファイル番号読み込み
        readFileNumber()
        // 今日の日付
        let today = Date()
        // 今日と前後1日の日記ページ読み込み
        nikkiPages.loadNikkiPagesByYesterdayTodayTomorrow(date: today)
        // 今月のカレンダーに表示するデータ読み込み
        // 処理未作成
    }
    
    /// 日記データを保存する
    func save() {
        
    }

}
