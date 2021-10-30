//
//  RecipeDetailView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/17/21.
//

import SwiftUI

struct RecipeDetailView: View {
    
    var recipe:Recipe
    
    @State var selectedServingSize = 2
    
    var body: some View {
        ScrollView {
            
            // We put the entire ScrollView into a VStack so that we could align everything together
            
            VStack(alignment: .leading) {
                
                // These marks can help to navigate through the code
                // They create a label in the navigation string above this pane
                // MARK: Recipe Image
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                
                // MARK: Recipe Title
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.leading)
                
                // MARK: Serving Size Picker
                VStack(alignment: .leading) {
                    Text("Select your serving size")
                    Picker("", selection: $selectedServingSize) {
                        Text("2").tag(2)
                        Text("4").tag(4)
                        Text("6").tag(6)
                        Text("8").tag(8)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width:160)
                }
                .padding()
                
                // MARK: Ingredients
                
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding([.bottom, .top], 5)
                    
                    ForEach (recipe.ingredients) { item in
                        
                        // Here we google searched "unicode dot", clicked the first result and copy/pasted the dot itself
                        // the '.lowercased()' syntax detects capital letters and changes them to lowercase
                        // Here, we're running the getPortion method in the RecipeModel, passing in our parameters and displaying what the method returns along with a bullet point before and the lowercased version of the item name after
                        
                        Text("• " + RecipeModel.getPortion(ingredient: item, recipeServings: recipe.servings, targetServings: selectedServingSize) + " " + item.name.lowercased())
                    }
                }
                // This is just padding on the left and right at the same time
                .padding(.horizontal)
                
                // MARK: Divider
                // This looks like it sort of just adds a thin little line to help the UI give a little extra visual separation between the ingredients list and the directions
                
                Divider()
                
                // MARK: Directions
                VStack(alignment: .leading) {
                    Text("Directions")
                        .font(.headline)
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<recipe.directions.count, id: \.self) { index in
                        Text(String(index + 1) + ". " + recipe.directions[index])
                            .padding(.bottom, 5)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Create a dummy recipe and pass it into the detail view so that we can see a preview
        // We have to do this since our 'recipe' variable above is not preloaded with anything so the normal preview code throws an error
        
        let model = RecipeModel()
        
        RecipeDetailView(recipe: model.recipes[0])
    }
}
