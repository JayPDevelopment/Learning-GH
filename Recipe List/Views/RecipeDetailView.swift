//
//  RecipeDetailView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/17/21.
//

import SwiftUI

struct RecipeDetailView: View {
    
    var recipe:Recipe
    
    var body: some View {
        ScrollView {
            
            // We put the entire ScrollView into a VStack so that we could align everything together
            
            VStack(alignment: .leading) {
                
                // We could add a title in here but it would be cool to have that just be a part of the navigation bar title from the navigation list from the list view (see navigationBarTitle attached to the end of the ScrollView
                
                // These marks can help to navigate through the code
                // They create a label in the navigation string above this pane
                // MARK: Recipe Image
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                
                // MARK: Ingredients
                
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding([.bottom, .top], 5)
                    
                    ForEach (recipe.ingredients, id: \.self) { item in
                        
                        // Here we google searched "unicode dot", clicked the first result and copy/pasted the dot itself
                        
                        Text("• " + item)
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
        .navigationBarTitle(recipe.name)
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
