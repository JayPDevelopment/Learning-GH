//
//  DataService.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import Foundation

class DataService {
    
    // If all we're using this class for is to call this method, we can make this into a static method or type method
    // This means we can call the function directly without having to call an instance of the class first.
    // See the RecipeModel for how this works in action
    static func getLocalData() -> [Recipe] {
        
        // Parse local json file
        
        // Get a url path to the json file
        let pathString = Bundle.main.path(forResource: "recipes", ofType: "json")
        
        // Check if pathString is not nil, otherwise
        // If pathString IS nil, we'll just return an empty array of 'Recipe'
        // Pretty slick...
        guard pathString != nil else {
            return [Recipe]()
        }
        
        // Create a url object
        // Force unwrap pathString since we checked it above
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            // Create a data object
            let data = try Data(contentsOf: url)
            
            // Decode the data with a JSON decoder
            let decoder = JSONDecoder()
            
            do {
                
                let recipeData = try decoder.decode([Recipe].self, from: data)
                
                // Add the unique IDs
                for r in recipeData {
                    r.id = UUID()
                    
                    // Add unique ids to recipe ingredients
                    for i in r.ingredients {
                        i.id = UUID()
                    }
                }
                // Return the recipes
                return recipeData
            }
            catch {
                // error with parsing json
                print(error)
            }
        }
        catch {
            // Error with gatting data
            print(error)
        }
        
        return [Recipe]()
    }
}
