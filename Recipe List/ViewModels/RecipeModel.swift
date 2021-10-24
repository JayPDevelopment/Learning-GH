//
//  RecipeModel.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import Foundation

class RecipeModel: ObservableObject {
    
    @Published var recipes = [Recipe]()
    
    init() {
        
        // Parse the local json file and set the recipes property
        
        // Instead of writing here, we'll put all the code that fetches data into the 'Services' folder
        // As our project grows, we could have multiple view models that could use this same code
        // Instead of repeating it in every view model, we'll refactor it into it's own class
        
        // Create an instance of DataService and get the data
        // let service = DataService()
        // self.recipes = service.getLocalData()
        
        // we could compress this into self.recipes = DataService().getLocalData()
        
        // We're gonna do one better and call the type method directly and store it in the recipes property
        
        self.recipes = DataService.getLocalData()
    }
    
    
    // We're using this method to organize our ingredients list such that it updates with changes to the servings Picker
    // Making the method static means we can call the method without creating an instance of RecipeModel
    
    static func getPortion(ingredient:Ingredient, recipeServings:Int, targetServings:Int) -> String {
        
        // As we move through this code, we create a 'portion' variable and build the empty string up piece by piece based on the various conditions presented.  We then create a unit variable and alter it based on those same conditions.  We then return the portion + unit.
        // We also have a catch-all built in that just returns an empty string for items like "salt and pepper to taste" that have no protions or units
        
        // Here we declare a variable to store the string that we are going to return
        var portion = ""
        // This syntax is called a 'nil coalescing operator' and it means that if the value of ingredient.num or ingredient.denom comes in as nil, it will be set to '1' rather than nil
        var numerator = ingredient.num ?? 1
        var denominator = ingredient.denom ?? 1
        var wholePortions = 0
        
        if ingredient.num != nil {
            
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
