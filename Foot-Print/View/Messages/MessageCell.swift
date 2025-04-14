//
//  MessageCell.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-14.
//

import SwiftUI

struct MessageCell: View {
    
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            Rectangle()
                .frame(width: width, height: 1, alignment: .center)
                .foregroundColor(.gray)
                .opacity(0.3)
            
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .cornerRadius(30)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0, content: {
                    HStack {
                        Text("Solo ")
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("@solo_hiker")
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("14/05/25")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    
                    Text("You: Hey! How is it going?")
                        .foregroundColor(.gray)
                    
                    Spacer()
                })
            }
            .padding(.top, 2)
        })
        .frame(width: width, height: 84)
    }
}

#Preview {
    MessageCell()
}
