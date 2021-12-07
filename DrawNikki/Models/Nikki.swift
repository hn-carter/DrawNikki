//
//  Nikki.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/06.
//

import Foundation
import CoreData
import os

/// 絵日記のページを管理するレコード
struct NikkiRecord {
    var id: UUID?
    var date: Date?
    var number: Int
    var picture_filename: String?
    var text_filename: String?
    var created_at: Date?
    var updated_at: Date?

    init(number: Int) {
        self.number = number
        self.created_at = nil
        self.updated_at = nil
    }
    init(cdNikki: Nikki) {
        self.id = cdNikki.id
        self.date = cdNikki.date
        self.number = Int(cdNikki.number)
        self.picture_filename = cdNikki.picture_filename
        self.text_filename = cdNikki.text_filename
        self.created_at = cdNikki.created_at
        self.updated_at = cdNikki.updated_at
    }
}

/// CoreDataを扱う
struct NikkiRepository {
    // CoreDataをカプセル化したコンテナ
    let container: NSPersistentContainer
    
    let logger = Logger(subsystem: "DrawNikki.NikkiRepository", category: "NikkiRepository")
    
    init(controller: PersistenceController) {
        container = controller.container
    }
    
    /// 日記データを取得する
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 結果
    func getNikkiInMonth(calendar: Calendar, year: Int, month: Int) -> [NikkiRecord] {
        var items:[Nikki] = []
        let request: NSFetchRequest = Nikki.fetchRequest()
        //　検索条件
        // 月の初日を取得
        let firstDay = Date(calendar: calendar, year: year, month: month, day: 1)
        // 翌月の初日を取得
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@",
                                    firstDay as CVarArg, nextMonth as CVarArg)
        request.predicate = predicate
        // ソート条件
        request.sortDescriptors = [NSSortDescriptor(key: "date, number", ascending: true)]
        do {
            items = try container.viewContext.fetch(request)
        } catch {
            logger.error("error in fetching data from File_number")
        }
        // 型変換して返す
        return items.map{ NikkiRecord(cdNikki: $0) }
    }
    
    
    /// 日記レコード追加
    /// - Parameter item: 登録データ
    func createNikki(item: NikkiRecord) {
        let newItem = Nikki(context: container.viewContext)
        
        newItem.id = item.id ?? UUID()
        newItem.date = item.date
        newItem.number = Int32(item.number)
        newItem.picture_filename = item.picture_filename
        newItem.text_filename = item.text_filename
        newItem.created_at = item.created_at
        newItem.updated_at = item.updated_at
        
        save()
    }
    
    /// CoreDataに保存する
    private func save() {
        if !container.viewContext.hasChanges { return }
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            logger.error("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
