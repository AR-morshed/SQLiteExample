//
//  ContentView.swift
//  SQLiteExample
//
//  Created by Arman Morshed on 5/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var title: String = ""
    
    var body: some View {
        ZStack {
            VStack {
            SearchBar(text: $title)
            
            List(DatabaseManager.shared.getAlbumsUsingFor(search: title), id: \.self) { album in
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Album ID: \(album.albunId)")
                        .font(.body)
                    Text(album.title)
                        .font(.body)
                    Text("Artist ID: \(album.artistId)")
                        .font(.body)
                }
                
            }
            }
        }.ignoresSafeArea(edges: .all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
