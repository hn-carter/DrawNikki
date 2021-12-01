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
    
   
    init() {
        self.pageVM = PageViewModel(picture: nil)
        
        // データテスト
        let file_num: File_number
        var fileNum: NSFetchRequest<File_number>
        fileNum = File_number.allFetchRequest()
        print(fileNum)
    }
    
    func initialize() {
        
    }
    
    func getAllData() -> [File_number] {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        
        let request = NSFetchRequest<File_number>(entityName: "File_number")
        // 日付で昇順にソート
        request.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        
        do {
            let tasks = try context.fetch(request)
            return tasks
        }
        catch {
            fatalError()
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
