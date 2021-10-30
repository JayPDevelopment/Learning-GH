//
//  Recipe_ListApp.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/16/21.
//

import SwiftUI

@main
struct Recipe_ListApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RecipeTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
