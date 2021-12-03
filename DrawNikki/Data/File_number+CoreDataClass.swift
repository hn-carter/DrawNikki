//
//  File_number+CoreDataClass.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/30.
//
//

import Foundation
import CoreData

@objc(File_number)
public class File_number: NSManagedObject {
   
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

}
