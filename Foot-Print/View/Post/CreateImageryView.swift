//
//  CreateTweetView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-03-29.
//

import SwiftUI

struct CreateImageryView: View {
    
    @State var text = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Cancel")
                })
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("Write").padding()
                })
                .background(Color("bg"))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            
            MultilineTextField(text:  $text)
        }
        .padding()
    }
}

#Preview {
    CreateImageryView()
}
