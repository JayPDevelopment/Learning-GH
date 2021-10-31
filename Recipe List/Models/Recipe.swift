//
//  Recipe.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import Foundation

// We need to preserve these models for first time app use so that we can parse the json data and add it to core data
// We added 'JSON' to the model names so they don't clash with our core data models
class RecipeJSON: Identifiable, Decodable {
    
    var id:UUID?
    var name:String
    var featured:Bool
    var image:String
    var description:String
    var prepTime:String
    var cookTime:String
    var totalTime:String
    var servings:Int
    var highlights:[String]
    var ingredients:[IngredientJSON]
    var directions:[String]
    
}

class IngredientJSON: Identifiable, Decodable {
    
    var id:UUID?
    var name:String = ""
    var num:Int?
    var denom:Int?
    var unit:String?
}
