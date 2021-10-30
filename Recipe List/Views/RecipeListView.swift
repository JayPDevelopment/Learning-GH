//
//  ContentView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import SwiftUI

struct RecipeListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // This is how we populate the model variable with our "master" instance of RecipeModel
    @EnvironmentObject var model:RecipeModel
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading){
                
                Text("All Recipes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                ScrollView {
                    
                    // A lazy vstack only creates or renders items as needed
                    // When you have a ton of rows, you don't want your phone to allocate memory to EVERY row, just the ones being displayed or used
                    LazyVStack (alignment: .leading) {
                        
                        ForEach (model.recipes) { r in
                            
                            NavigationLink {
                                RecipeDetailView(recipe: r)
                            } label: {
                                HStack(spacing: 20.0) {
                                    let image = UIImage(data: r.image ?? Data()) ?? UIImage()
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .clipped()
                                        .cornerRadius(5)
                                    
                                    VStack(alignment: .leading) {
                                        Text(r.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        RecipeHighlights(highlights: r.highlights)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Here, we're trying to format the app so that the View title matches our featured view
                // Basically, we're eliminating the automatically displayed navigationBarTitle and adding our own text element above that matches the rest of our app (the featured view
                // .navigationBarTitle("All Recipes")
                .navigationBarHidden(true)
            }
            .padding(.leading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeModel())
    }
}
