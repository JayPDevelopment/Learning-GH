//
//  AddRecipeView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/30/21.
//

import SwiftUI

struct AddRecipeView: View {
    
    // Properties for recipe meta data
    @State private var name = ""
    @State private var summary = ""
    @State private var prepTime = ""
    @State private var cookTime = ""
    @State private var totalTime = ""
    @State private var servings = ""
    
    // List type recipe meta data
    @State private var highlights = [String]()
    @State private var directions = [String]()
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button("Clear") {
                    // Clear the form
                }
                
                Spacer()
                
                Button("Add") {
                    // Add the recipe to core data
                    // Clear the form
                }
            }
            
            ScrollView (showsIndicators: false){
                
                VStack {
                    
                    // The recipe meta data
                    AddMetaData(name: $name, summary: $summary, prepTime: $prepTime, cookTime: $cookTime, totalTime: $totalTime, servings: $servings)
                    
                    // List data
                    AddListData(list: $highlights, title: "Highlights", placeholderText: "Vegetarian")
                    
                    AddListData(list: $directions, title: "Directions", placeholderText: "Add the oil to the pan")
                }
            }
        }
        .padding(.horizontal)
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
