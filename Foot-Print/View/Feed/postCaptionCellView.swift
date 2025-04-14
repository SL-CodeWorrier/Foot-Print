//
//  TweetCellView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-01.
//

import SwiftUI

struct postCaptionCellView: View {
    
    var postCaption: String
    var postImage: String?
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10, content: {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 10, content: {(
                    Text("Solo ")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    +
                    Text("@Solo_Hiker")
                        .foregroundColor(.gray)
                    )
                    
                    Text(postCaption)
                        .frame(maxHeight: 100, alignment: .top)
                    
                    if let image = postImage {
                        GeometryReader { proxy in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: proxy.frame(in: .global).width, height: 250, alignment: .center)
                                .cornerRadius(15)
                        }
                        .frame(height: 250)
                    }
                
                })
            })
            
            // Cell Bottom
            
            HStack(spacing: 50, content: {
                Button(action: {
                    
                }, label: {
                    Image("comments").resizable()
                        .frame(width: 16, height: 16)
                }).foregroundColor(.gray)
                
                Button(action: {
                    
                }, label: {
                    Image("repost").resizable()
                        .frame(width: 18, height: 14, alignment: .center)
                }).foregroundColor(.gray)
                
                Button(action: {
                    
                }, label: {
                    Image("love").resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                }).foregroundColor(.gray)
                
                Button(action: {
                    
                }, label: {
                    Image("upload").resizable()
                        .frame(width: 18, height: 15)
                }).foregroundColor(.blue)
            })
            .padding(.top, 4)
        }
    }
}

#Preview {
    TravelCellView(post: sampleText)
}

var sampleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."


