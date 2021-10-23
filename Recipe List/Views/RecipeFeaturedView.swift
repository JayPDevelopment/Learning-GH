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
        
        // We embedded all of our code into a geometry reader so that we can adjust the rectangle below
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Featured Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.top, 40)
            
            GeometryReader { geo in
                
                // TabView can also be used to create a swipeable card type of view
                TabView {
                    
                    // Loop through each recipe
                    ForEach (0..<model.recipes.count) { index in
                        
                        // Only show those that should be featured
                        if model.recipes[index].featured {
                            
                            // Recipe card
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    Image(model.recipes[index].image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                    Text(model.recipes[index].name)
                                        .padding(5)
                                }
                            }
                            .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: .center)
                            .cornerRadius(15)
                            // This creates the sexy floating card look
                            .shadow(color: .black, radius: 10, x: -5, y: 5)
                        }
                    }
                }
                // This is how we get the swipeable card effect
                // the indexDisplayMode is how to display the little dots on the bottom of the screen tracking which card you're on
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                // This creates a basic background for our dots so that they show up nicely even if the background is white
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Preparation Time")
                    .font(.headline)
                Text("1 Hour")
                Text("Highlights")
                    .font(.headline)
                Text("Healthy, Hearty")
            }
            .padding([.leading, .bottom])
        }
    }
}

struct RecipeFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        
        // HERE'S how you get the preview to work when you're messing with environment objects.
        RecipeFeaturedView()
            .environmentObject(RecipeModel())
    }
}
