//
//  SearchView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-03-15.
//

import SwiftUI

struct SearchView: View {
    
    @State var text = ""
    @State var isEditing = false
    
    var body: some View {
        VStack {
            
            SearchBar(text: $text, isEditing: $isEditing)
                .padding(.horizontal)
            
            if !isEditing {
                List(0..<9) { i in
                    SearchCell(tag: "Hello", footPrints: String(i))
                }
            }
            else {
                List(0..<9) { _ in
                    SearchUserCell()
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
