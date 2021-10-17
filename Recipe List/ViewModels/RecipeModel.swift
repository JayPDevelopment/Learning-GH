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
        
        // Parsed the local json file
        
        // Set the recipes property
        
        // Instead, we'll put all the code that fetches data into the 'Services' folder
        // As your project grows, you could have multiple view models that could use this same code
        // Instead of repeating it in every view model, we'll refactor it into it's own class
        
        // Create an instance of DataService and get the data
        // let service = DataService()
        // self.recipes = service.getLocalData()
        
        // we could compress this into self.recipes = DataService().getLocalData()
        
        // We're gonna do one better and call the type method directly
        self.recipes = DataService.getLocalData()
    }
}
