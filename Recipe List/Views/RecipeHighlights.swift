//
//  RecipeHighlights.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/23/21.
//

import SwiftUI

struct RecipeHighlights: View {
    
    var allHighlights = ""
    
    init(highlights:[String]) {
        
        //Loop through the highlights and build the string
        for index in 0..<highlights.count {
            
            // If this is the last item, don't add a comma
            if index == highlights.count - 1 {
                allHighlights += highlights[index]
            }
            else {
                allHighlights += highlights[index] + ", "
            }
        }
    }
    
    var body: some View {
        Text(allHighlights)
    }
}

struct RecipeHighlights_Previews: PreviewProvider {
    static var previews: some View {
        RecipeHighlights(highlights: ["test", "test 2"])
    }
}
