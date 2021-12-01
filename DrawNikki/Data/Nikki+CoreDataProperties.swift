//
//  Nikki+CoreDataProperties.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/30.
//
//

import Foundation
import CoreData


extension Nikki {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nikki> {
        return NSFetchRequest<Nikki>(entityName: "Nikki")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var number: Int32
    @NSManaged public var picture_filename: String?
    @NSManaged public var text_filename: String?
    @NSManaged public var updated_at: Date?

}

extension Nikki : Identifiable {

}
