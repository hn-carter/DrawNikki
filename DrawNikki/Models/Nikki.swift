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
    let logger = Logger(subsystem: "DrawNikki.NikkiRepository", category: "NikkiRepository")

    // CoreDataをカプセル化したコンテナ
    let container: NSPersistentContainer
    
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
        logger.trace("NikkiRepository.getMaxNumberOnDate \(date.toString())")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Nikki")
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
        request.resultType = .dictionaryResultType

        logger.debug("\(request)")

        do {
            let results = try container.viewContext.fetch(request)
            for rec in results {
                if let resultDict = rec as? [String: Any] {
                    if let maxNum = resultDict[key] as? Int {
                        logger.debug("取得できた \(maxNum)")
                        return (maxNum)
                    }
                }
            }
        } catch {
            logger.error("error in fetching number from Nikki")
        }
        
        // エラーを返す
        return -1
    }
    
    /// 日記レコード追加
    /// - Parameter item: 登録データ
    /// - Returns: 処理結果 true:正常
    func createNikki(item: NikkiRecord) -> Bool {
        logger.trace("NikkiRepository.createNikki")
        logger.debug("date: \(item.date!.toString()), number:\(item.number)")
        
        let discription = NSEntityDescription.entity(forEntityName: "Nikki", in: container.viewContext)!
        let newItem = Nikki(entity: discription, insertInto: container.viewContext)
        newItem.id = item.id ?? UUID()
        logger.debug("id: \(newItem.id!.uuidString)")

        newItem.date = item.date
        newItem.number = Int32(item.number)
        newItem.picture_filename = item.picture_filename
        newItem.text_filename = item.text_filename
        newItem.created_at = Date()
        newItem.updated_at = Date()
        container.viewContext.insert(newItem)

        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                let nsError = error as NSError
                logger.error("Unresolved error \(nsError), \(nsError.userInfo)")
                return false
            }
        } else {
            logger.debug("Nikki NikkiRepository.createNikki container.viewContext.hasChanges is false")
        }
        return true
    }
    
    
    /// 日記レコード更新
    /// - Parameter item: 更新データ
    /// - Returns: 処理結果 true:正常
    func updateNikki(item: NikkiRecord) -> Bool {
        logger.trace("NikkiRepository.updateNikki")
        let request: NSFetchRequest = Nikki.fetchRequest()
        let predicate = NSPredicate(format: "id = %@",
                                    item.id! as CVarArg)
        request.predicate = predicate
        do {
            let items = try container.viewContext.fetch(request)
            
            if items.count == 1 {
                items[0].date = item.date
                items[0].number = Int32(item.number)
                items[0].picture_filename = item.picture_filename
                items[0].text_filename = item.text_filename
                items[0].updated_at = Date()
            }

            try container.viewContext.save()
        } catch let error as NSError {
            logger.error("error in update page from Nikki \(error)")
            return false
        }
        return true
    }
    
    /// 日記レコード削除
    /// - Parameter item: 削除データ
    /// - Returns: 処理結果 true:正常
    func deleteNikki(item: NikkiRecord) -> Bool {
        logger.trace("NikkiRepository.deleteNikki")
        
        let request: NSFetchRequest = Nikki.fetchRequest()
        let predicate = NSPredicate(format: "id = %@",
                                    item.id! as CVarArg)
        request.predicate = predicate

        do {
            let records = try container.viewContext.fetch(request)

            for record in records {
                container.viewContext.delete(record)
            }

            try container.viewContext.save()
        } catch let error as NSError {
            logger.error("error in delete page from Nikki \(error)")
            return false
        }
        return true
    }
}
