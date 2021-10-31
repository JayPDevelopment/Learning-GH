//
//  ContentView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import SwiftUI

struct RecipeListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // @EnvironmentObject var model:RecipeModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var recipes: FetchedResults<Recipe>
    
    @State private var filterBy = ""
    
    private var filteredRecipes: [Recipe] {
        
        if filterBy.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return Array(recipes)
        }
        else {
            // Filter by the search term and return a subset of recipes which contain the search term in the name
            return recipes.filter { r in
                return r.name.contains(filterBy)
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading){
                
                Text("All Recipes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                SearchBarView(filterBy: $filterBy)
                    .padding([.trailing, .bottom])
                
                ScrollView {
                    
                    LazyVStack (alignment: .leading) {
                        
                        ForEach (filteredRecipes) { r in
                            
                            NavigationLink {
                                RecipeDetailView(recipe: r)
                            } label: {
                                HStack(spacing: 20.0) {
                                    // core data stores images as data type 'Data'
                                    // We have to load the image in the following manner now if it comes from core data
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
            }
            .navigationBarHidden(true)
            .padding(.leading)
            .onTapGesture {
                // Resign first responder
                // This allows us to click off of the search bar and close the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeModel())
    }
}
