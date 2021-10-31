//
//  RecipeFeaturedView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/21/21.
//

import SwiftUI

struct RecipeFeaturedView: View {
    
    // We altered our project to refer to some core data fetched results rather that this environment object
    //@EnvironmentObject var model:RecipeModel
    
    // Here we'll get slightly fancy and sort our results into alphabetical order, just cuz
    // We'll get even more fancy and filter the fetch request to only fetch data that is featured.  This way we can remove the 'if recipes[index].featured' statement below
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: NSPredicate(format: "featured == true")) var recipes: FetchedResults<Recipe>
    
    // This is our .sheet controlling variable for making our recipe cards into buttons
    @State var isDetailViewShowing = false
    
    // This is how we track which card is showing in our ForEach loop so that we can reference that recipe to fill in our Prep Time and Highlights section below the cards
    @State var tabSelectionIndex = 0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Featured Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.top, 40)
            
            GeometryReader { geo in
                
                // TabView can also be used to create a swipeable card type of view
                // The TabView can also capture the index of the selected tab.  We can then bind that to the tabSelectionIndex variable and store it there for use outside of the TabView
                TabView (selection: $tabSelectionIndex) {
                    
                    // Loop through each recipe
                    ForEach (0..<recipes.count) { index in
                    
                        // Recipe card button
                        Button(action: {
                            
                            //Show the recipe detail sheet
                            self.isDetailViewShowing = true
                        }) {
                            
                            // Recipe card
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    // core data stores images as data type 'Data'
                                    // We have to load the image in the following manner now if it comes from core data
                                    let image = UIImage(data: recipes[index].image ?? Data()) ?? UIImage()
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                    Text(recipes[index].name)
                                        .padding(5)
                                }
                            }
                        }
                        // Here we tag the card with the array index.  I think this is the tag that then gets bound to the tabSelectionIndex
                        .tag(index)
                        
                        // This allows us to slide up the RecipeDetailView when the button is tapped, changing isDetailViewShowing to true and running the .sheet modifier
                        // The '$' binds the variable so that when the user dismisses the popup view, the isDetailViewShowing goes back to 'false'
                        .sheet(isPresented: $isDetailViewShowing) {
                            // Show the RecipeDetailView
                            RecipeDetailView(recipe: recipes[index])
                        }
                        
                        // This keeps the Button from turning the text within the label blue
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: .center)
                        .cornerRadius(15)
                        // This creates the sexy floating card look
                        .shadow(color: .black, radius: 10, x: -5, y: 5)
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
                
                // We need access to the recipe being displayed to update the below data but that info is inside the ForEach loop.  So, we pull it out using the tabSelectionIndex
                Text(recipes[tabSelectionIndex].prepTime)
                
                Text("Highlights")
                    .font(.headline)
                
                // We made a separate view that processes the array of strings in the highlights section of the json data and displays a single text string containing those elements. We run it here.
                RecipeHighlights(highlights: recipes[tabSelectionIndex].highlights)
            }
            .padding([.leading, .bottom])
        }
        
        // Here's how we run our method setting the initial tabSelectionIndex.  We couldn't just run it as an init() because it would run too early.  It hasn't populated the tabview or ran the ForEach yet.  So, we put it in here instead
        .onAppear {
            setFeaturedIndex()
        }
    }
    
    // This method will find and set our initial tabSelectionIndex for us
    func setFeaturedIndex() {
        
        // Find the index of the first recipe that is featured
        // This syntax means find the first instance in the array where the featured property is true and then return the index of that instance, then store it in the 'index' variable
        var index = recipes.firstIndex { (recipe) -> Bool in
            return recipe.featured
        }
        
        // Here we store the index into our tabSelectionIndex variable.  If it returns nil, we'll just set it to zero
        tabSelectionIndex = index ?? 0
    }
}

struct RecipeFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        
        RecipeFeaturedView()
            .environmentObject(RecipeModel())
    }
}
