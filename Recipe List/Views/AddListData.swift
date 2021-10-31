//
//  AddListData.swift
//  Recipe List
//
//  Created by Justin Puuri on 10/30/21.
//

import SwiftUI

struct AddListData: View {
    
    @Binding var list: [String]
    
    @State private var item: String = ""
    
    var title: String
    var placeholderText: String
    
    
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            HStack {
                
                Text("\(title):")
                    .bold()
                TextField(placeholderText, text: $item)
                
                Button("Add") {
                    // Add the item to the list
                    if item.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        
                        // Add the item to the list
                        list.append(item.trimmingCharacters(in: .whitespacesAndNewlines))
                        
                        // Clear the text field
                        item = ""
                    }
                }
            }
            
            // List out the items added so far
            // We originally used a list here but it didn't work because appending items to our array of strings wasn't enough to key a UI change, despite it being a @State property. However, it was enough to key a change in the ForEach function
            ForEach (list, id: \.self) { item in
                Text(item)
            }
        }
    }
}

