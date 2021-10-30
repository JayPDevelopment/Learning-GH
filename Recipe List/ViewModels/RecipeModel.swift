//
//  RecipeModel.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import Foundation
import UIKit

class RecipeModel: ObservableObject {
    
    // Reference to the managed object context
    let managedObjectContext = PersistenceController.shared.container.viewContext
    
    @Published var recipes = [Recipe]()
    
    init() {
        
        // Check if we have already pre-loaded the data into core data
        checkLoadedData()
    }
    
    func checkLoadedData() {
        
        // Check local storage for the flag
        // We stored the nomenclature for this flag in the Constants file, probably just to keep track of them
        // Instead of 'Constants.isDataPreloaded' we probably could have passed in "isDataPreloaded" and that key would be searched for in UserDefaults.  It would return false if it either didn't find the key or it found it and it contained false.
        // I think this syntax itself might create the key?  If not, it will be officially created when you set its value at the end of this function
        let status = UserDefaults.standard.bool(forKey: Constants.isDataPreloaded)
        
        // If it's false, then we should parse the local json and preload into core data
        if status == false {
            preloadLocalData()
        }
    }
    
    func preloadLocalData() {
        
        // Parse the local json file
        let localRecipes = DataService.getLocalData()
        
        // Create core data objects
        for r in localRecipes {
            
            // Create a core data object
            let recipe = Recipe(context: managedObjectContext)
            
            // Set the core data object's properties using the json object properties
            recipe.cookTime = r.cookTime
            recipe.directions = r.directions
            recipe.featured = r.featured
            recipe.highlights = r.highlights
            // Here we'll just create an actual UUID
            recipe.id = UUID()
            // Here is how we turn an asset image into the 'Data' data type needed for core data
            // Note that it's necessary to have UIKit imported in order to use UIImage
            // For some reason we needed to load the managedObjectContext variable into our RecipeModel to get this to work?
            // the 'named' initializer passes in a string and looks in the asset library for the name
            // the UIImage then has a property called jpegData that gives you the data representation of the image
            // if this returns nil, that's ok because our image property is optional
            recipe.image = UIImage(named: r.image)?.jpegData(compressionQuality: 1.0)
            recipe.name = r.name
            recipe.prepTime = r.prepTime
            recipe.servings = r.servings
            recipe.summary = r.description
            recipe.totalTime = r.totalTime
            
            // Set the ingredients
            for i in r.ingredients {
                
                // Create a core data ingredient object
                let ingredient = Ingredient(context: managedObjectContext)
                
                ingredient.id = UUID()
                ingredient.name = i.name
                ingredient.unit = i.unit
                // The num/denom is supposed to be optional but due to our bug, we can't set our ints to optional.  So, we check for nil and enter '1' if it's nil.  This way our quantitites just turn out to be 1 if there some willy nilly going on
                ingredient.num = i.num ?? 1
                ingredient.denom = i.denom ?? 1
                
                // Add this to the recipe
                // Our core data model for Recipe has a handy function we can use to add this to our model
                recipe.addToIngredients(ingredient)
            }
        }
        
        // Save into core data
        do {
            try managedObjectContext.save()
            
            // Set local storage flag
            // I think that if the save code above is not successful, it will skip this and go to catch
            // Here we again link to 'Constants.isDataPreloaded' for our nomenclature that we want to use for the Key.  We then set that key to 'true' in the User Defaults.
            UserDefaults.standard.setValue(true, forKey: Constants.isDataPreloaded)
        }
        catch {
            // Couldn't save to core data
        }
    }
    
    // We're using this method to organize our ingredients list such that it updates with changes to the servings Picker
    // Making the method static means we can call the method without creating an instance of RecipeModel
    
    static func getPortion(ingredient:Ingredient, recipeServings:Int, targetServings:Int) -> String {
        
        // As we move through this code, we create a 'portion' variable and build the empty string up piece by piece based on the various conditions presented.  We then create a unit variable and alter it based on those same conditions.  We then return the portion + unit.
        // We also have a catch-all built in that just returns an empty string for items like "salt and pepper to taste" that have no protions or units
        
        // Here we declare a variable to store the string that we are going to return
        var portion = ""
        // This syntax is called a 'nil coalescing operator' and it means that if the value of ingredient.num or ingredient.denom comes in as nil, it will be set to '1' rather than nil
        var numerator = ingredient.num
        var denominator = ingredient.denom
        var wholePortions = 0
        
            
        // Get a single serving size by multiplying denominator by the recipe servings
        denominator *= recipeServings
        
        // Get target portion by multiplying numerator by target servings
        numerator *= targetServings
        
        // Reduce fraction by greatest common divisor
        // We added the Rational structure in the Utilities folder that has a method written to solve this.  It takes the num and denom as inputs and spits out the common divisor that can reduce the fraction for us.
        let divisor = Rational.greatestCommonDivisor(numerator, denominator)
        numerator /= divisor
        denominator /= divisor
        
        // Get the whole portion if numerator > denominator
        if numerator >= denominator {
            
            // Calculate the whole portions
            // This equation could yield a decimal value.  It's assigning it to a variable with an Int data type, though, so it just drops the decimal and stores the whole number.
            wholePortions = numerator / denominator
            
            // This syntax returns the remainder.  Its called 'modulo operation'.
            numerator = numerator % denominator
            
            // Assign to portion string
            // When working with strings, += means 'append'
            portion += String(wholePortions)
        }
            
            // Express the remainder as a fraction
            // First, we check if there is a remainder at all
            if numerator > 0 {
                
                // Assign remainder as fraction to the portion string
                // New way to express an if statement
                // This means to  check if wholePortions is greater that zero.  If its true, it will tack on " " and if it's not, it will tack on nothing ""
                portion += wholePortions > 0 ? " " : ""
                portion += "\(numerator)/\(denominator)"
            }
        
        
        // Now we address the units, if there are any
        // We changed the 'if let' to 'if var' so that we could change this within our statement
        if var unit = ingredient.unit {
            
            // If we need to pluralize the unit
            if wholePortions > 1 {
                
                // Calculate appropriate suffix
                // This syntax means "if the last two characters of the 'unit' is "ch" then...
                if unit.suffix(2) == "ch" {
                    
                    // We change the unit variable here, prompting the need to use an 'if var' statement
                    unit += "es"
                }
                
                // This is specifically for the 'leaf' unit.  If the last character of the 'unit' is "f" then...
                else if unit.suffix(1) == "f" {
                    
                    // This dropLast method returns all of the characters except the last one
                    // Here's another spot where we change the 'unit' variable
                    unit = String(unit.dropLast())
                    unit += "ves"
                }
                
                // And our catch-all pluralization if the above conditions aren't met is to just add an 's'
                else {
                    unit += "s"
                }
            }
            
            // Now...if there's not an actual quantity in this particular ingredient, we'll tack on nothing, but if there is, we'll add a space
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            
            // Now we just return the portion variable along with our updated unit variable
            return portion + unit
        }
        
        // Here's our catch-all if there's no portions or units to be used, as in "Salt and pepper to taste"
        return portion
    }
}
