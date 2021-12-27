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
    
    /// 日付から日記ページを配列で返す
    /// - Parameters:
    ///   - date: 取得日
    /// - Returns: 日記ページ配列
    func getNikkiOnDay(date: Date) -> [NikkiRecord] {
        var items:[Nikki] = []
        let request: NSFetchRequest = Nikki.fetchRequest()
        //　検索条件
        // 1日の始まりを取得
        let startDay = date.removeTimeStamp(calendar: Constants.dbCalendar)
        // 翌日の始まりを取得
        let nextDay = Constants.dbCalendar.date(byAdding: .day, value: 1, to: startDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@",
                                    startDay as CVarArg, nextDay as CVarArg)
        request.predicate = predicate
        // ソート条件
        request.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        do {
            items = try container.viewContext.fetch(request)
        } catch {
            logger.error("error in fetching some pages from Nikki")
        }
        // 型変換して返す
        return items.map{ NikkiRecord(cdNikki: $0) }
    }
    
    /// 1日の日記ページ数を返す
    /// - Parameters:
    ///   - date: 対象日
    /// - Returns: ページ数、エラーなら-1を返す
    func getMaxNumberOnDate(date: Date) -> Int {
        let request: NSFetchRequest = Nikki.fetchRequest()
        //　検索条件
        // 日の始まりを取得
        let components = Constants.dbCalendar.dateComponents([.year, .month, .day], from: date)
        let year: Int = components.year!
        let month: Int = components.month!
        let day: Int = components.day!
        let startDay = Date(calendar: Constants.dbCalendar, year: year, month: month, day: day)
        // 翌日を取得
        let nextDay = Constants.dbCalendar.date(byAdding: .day, value: 1, to: startDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@",
                                    startDay as CVarArg, nextDay as CVarArg)
        request.predicate = predicate
        
        // その日の最大番号を取得
        let keyPathExpression = NSExpression(forKeyPath: "number")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
        let key = "maxNumber"
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = key
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer32AttributeType
        request.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try container.viewContext.fetch(request)
            if let maxNum = results.first?.value(forKey: key) as? Int {
                return Int(maxNum)
            }
        } catch {
            logger.error("error in fetching number from Nikki")
        }
        
        // エラーを返す
        return -1
    }
    
    /// 日記レコード追加
    /// - Parameter item: 登録データ
    /// - Returns: 処理結果
    func createNikki(item: NikkiRecord) -> Bool {
        let newItem = Nikki(context: container.viewContext)
        
        newItem.id = item.id ?? UUID()
        newItem.date = item.date
        newItem.number = Int32(item.number)
        newItem.picture_filename = item.picture_filename
        newItem.text_filename = item.text_filename
        newItem.created_at = item.created_at
        newItem.updated_at = item.updated_at
        
        return save()
    }
    
    /// CoreDataに保存する
    /// - Returns: 処理結果
    private func save() -> Bool {
        if !container.viewContext.hasChanges { return false }
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            logger.error("Unresolved error \(nsError), \(nsError.userInfo)")
            return false
        }
        return true
    }
}
