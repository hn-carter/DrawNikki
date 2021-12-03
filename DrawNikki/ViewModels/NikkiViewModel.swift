//
//  NikkiViewModel.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/25.
//

import Foundation
import SwiftUI
import CoreData

class NikkiViewModel: ObservableObject {
    @Published var pageVM: PageViewModel
    
    @Published var fnumber: Int = 0
    
    @Published var updateItem : File_number! = nil

    init() {
        self.pageVM = PageViewModel(picture: nil)
        
    }
    
    func initialize() {
        
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
