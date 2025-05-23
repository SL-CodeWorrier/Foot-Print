//
//  CustomProfileBioTextField.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import SwiftUI

struct CustomProfileBioTextField: View {
    
    @Binding var bio: String
    
    var body: some View {
        VStack{
            ZStack(alignment: .top){
                if bio.isEmpty{
                    HStack{
                        Text("Add the bio to you profile")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.leading, 4)
                    .zIndex(1)
                    
                    TextEditor(text: $bio)
                        .foregroundColor(.blue)
                }
            }
        }
        .frame(height: 90)
    }
}
