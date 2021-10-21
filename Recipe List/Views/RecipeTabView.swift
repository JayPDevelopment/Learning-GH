//
//  RecipeTabView.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/17/21.
//

import SwiftUI

struct RecipeTabView: View {
    var body: some View {
        TabView {
            RecipeFeaturedView()
                .tabItem {
                    VStack {
                        Image(systemName: "star.fill")
                        Text("Featured")
                    }
                }
            
            ContentView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }
            // This modifier creates an instance of RecipeModel that all of the subviews after it can use.  This way, we don't repeatedly and unnecessarily run our DataService for every view.
        }.environmentObject(RecipeModel())
    }
}

struct RecipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTabView()
    }
}
