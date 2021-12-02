//
//  FileNumber.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/01.
//

import Foundation
import CoreData
import os

struct FileNumberRecord {
    var number: Int?
    var created_at: Date?
    var updated_at: Date?

    init(number: Int?) {
        self.number = number
        self.created_at = nil
        self.updated_at = nil
    }
}


struct FileNumberRepository {
    // CoreDataをカプセル化したコンテナ
    let container: NSPersistentContainer
    
    let logger = Logger(subsystem: "DrawNikki.FileNumberRepository", category: "FileNumberRepository")
    
    init(controller: PersistenceController) {
        container = controller.container
    }
    
    /// CoreDataからファイルにつけた最終番号を取s得する
    /// - Returns: 最後にファイルにつけた番号
    func getFileNumber() -> Int {
        var items:[File_number] = []
        let request: NSFetchRequest = File_number.fetchRequest()
        do {
            items = try container.viewContext.fetch(request)
        } catch {
            logger.error("error in fetching data from File_number")
        }
        if items.count == 0 {
            return 0
        }
        return Int(items[0].number)
    }
}
