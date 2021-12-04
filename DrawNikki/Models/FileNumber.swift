//
//  FileNumber.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/01.
//

import Foundation
import CoreData
import os


/// ファイルの番号を管理するレコード
struct FileNumberRecord {
    var number: Int
    var created_at: Date?
    var updated_at: Date?

    init(number: Int) {
        self.number = number
        self.created_at = nil
        self.updated_at = nil
    }
    init(cdfn: File_number) {
        self.number = Int(cdfn.number)
        self.created_at = cdfn.created_at
        self.updated_at = cdfn.updated_at
    }
}



/// CoreDataを扱う
struct FileNumberRepository {
    // CoreDataをカプセル化したコンテナ
    let container: NSPersistentContainer
    
    let logger = Logger(subsystem: "DrawNikki.FileNumberRepository", category: "FileNumberRepository")
    
    init(controller: PersistenceController) {
        container = controller.container
    }
    
    /// CoreDataからファイル番号管理データを取得する
    /// - Returns: レコード
    func getFileNumber() -> FileNumberRecord? {
        var items:[File_number] = []
        let request: NSFetchRequest = File_number.fetchRequest()
        do {
            items = try container.viewContext.fetch(request)
        } catch {
            logger.error("error in fetching data from File_number")
        }
        if items.count == 0 {
            return nil
        }
        let fn = FileNumberRecord(cdfn: items[0])
        return fn
    }
    
    // 新規レコード追加
    func createFileNumber(item: FileNumberRecord) {
        let newItem = File_number(context: container.viewContext)
        newItem.number = Int32(item.number)
        newItem.created_at = item.created_at
        newItem.updated_at = item.updated_at
        
        save()
    }
    
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
