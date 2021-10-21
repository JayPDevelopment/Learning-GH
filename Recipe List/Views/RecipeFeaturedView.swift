//
//  RecipeFeaturedView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/21/21.
//

import SwiftUI

struct RecipeFeaturedView: View {
    
    // This is how we populate the model variable with our "master" instance of RecipeModel
    @EnvironmentObject var model:RecipeModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RecipeFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFeaturedView()
    }
}
