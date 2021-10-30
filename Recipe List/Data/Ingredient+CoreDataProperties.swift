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

    // We dropped the '64' from the Ints
    // We changed our optionals to match what we want
    // We wanted 'num' and 'denom' to be optionals but a bug won't allow that
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var num: Int
    @NSManaged public var denom: Int
    @NSManaged public var unit: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
