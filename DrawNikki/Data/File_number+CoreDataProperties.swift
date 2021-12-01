//
//  File_number+CoreDataProperties.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/30.
//
//

import Foundation
import CoreData

// Core Dataがプロパティを書き込むときに使用する
extension File_number {
    
    /// データを取得するためのメソッド
    /// - Returns: <#description#>
    @nonobjc public class func fetchRequest() -> NSFetchRequest<File_number> {
        return NSFetchRequest<File_number>(entityName: "File_number")
    }

    @NSManaged public var number: Int32
    @NSManaged public var updated_at: Date?
    @NSManaged public var created_at: Date?

}

extension File_number : Identifiable {

}
