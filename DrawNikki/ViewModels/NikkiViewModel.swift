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
    @Published var pageVM: PageViewModel
    
    @Published var fnumber: Int = 0
    
    @Published var updateItem : File_number! = nil

    let logger = Logger(subsystem: "DrawNikki.NikkiViewModel", category: "NikkiViewModel")
    let cdController: PersistenceController
    var fileNumber: Int = 0
    
    init() {
        self.pageVM = PageViewModel(picture: nil)
        self.cdController = PersistenceController()
    }
    
    func initialize() {
        
    }
    
    
    /// ファイルの番号を取得する
    func readFileNumber() {
        // TEST
        let fn = FileNumberRepository(controller: cdController)
        if let record = fn.getFileNumber() {
            // データあり
            fileNumber = Int(record.number)
            logger.info("log coredata exist \(self.fileNumber)")
        } else {
            // データなし
            logger.info("log File_number is nil")
            var newItem = FileNumberRecord(number: 0)
            newItem.created_at = Date()
            newItem.updated_at = Date()
            fn.createFileNumber(item: newItem)
            
            fileNumber = 0
        }
        // データ更新
        let updateItem = FileNumberRecord(number: fileNumber + 1)
        let ret = fn.updateFileNumber(item: updateItem)
        if ret {
            logger.info("log fn.updateFileNumber = true")
        } else {
            logger.info("log fn.updateFileNumber = false")
        }
        // 再取得
        if let uprecord = fn.getFileNumber() {
            // データあり
            fileNumber = Int(uprecord.number)
            logger.info("log updated \(self.fileNumber)")
        } else {
            // データなし
            logger.info("log updated File_number is nil")
        }
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
        
        pageVM = PageViewModel(picture: nil)
    }
    
    /// 日記データを読み込む
    func load() {
        
    }
    
    /// 日記データを保存する
    func save() {
        
    }

}
