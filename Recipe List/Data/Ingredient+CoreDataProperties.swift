//
//  Ingredient+CoreDataProperties.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/30/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var num: Int
    @NSManaged public var denom: Int
    @NSManaged public var unit: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
