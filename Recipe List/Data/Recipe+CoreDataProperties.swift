//
//  Recipe+CoreDataProperties.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/30/21.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    // We dropped the '64' from the Ints
    // We changed our optionals to match what we want
    // Note that the data type for ingredients must be 'NSSet' in order to link to the Ingredients class in core data.  We'll have to manage this data type when we try to display this property by converting this data type into the array of strings that we'd like it to be.
    // Note also that the image data type is 'Data'.  This is necessary in order to store the image into core data.  We'll have to manage this data type when we try to display this property by calling the data into a variable and passing it into an Image() object.  We keep it optional here so that we don't force the app user to add an image if they don't want to.
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var featured: Bool
    @NSManaged public var image: Data?
    @NSManaged public var summary: String
    @NSManaged public var prepTime: String
    @NSManaged public var cookTime: String
    @NSManaged public var totalTime: String
    @NSManaged public var servings: Int
    @NSManaged public var highlights: [String]
    @NSManaged public var directions: [String]
    @NSManaged public var ingredients: NSSet

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension Recipe : Identifiable {

}
