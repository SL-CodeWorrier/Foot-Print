//
//  TweetCellView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-01.
//

import SwiftUI
import Kingfisher

struct postCaptionCellView: View {
    
    @ObservedObject var viewModel: TweetCellViewModel
    @State private var isNavigating = false
    
    var dislike: Bool {
        return viewModel.tweet.dislike ?? false
    }
    
    init(viewModel: TweetCellViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10, content: {
                
                /*
                if let user = viewModel.user{
                    NavigationLink(destination: UserProfile(user: user)){
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .onTapGesture {
                                        print("Tapped profile of \(user.username)")
                                    }
                    }
                }
                 */
                
                
                /*
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                    .onAppear {
                            print("viewModel.user: \(String(describing: viewModel.user))")
                        }
                 */
                
                if let user = viewModel.user {
                    NavigationLink(destination: UserProfile(user: user), isActive: $isNavigating) {
                                    Image("logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 55, height: 55)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            // Perform your action, like printing
                                            print("Tapped profile of \(user.username)")

                                            // Step 3: Trigger navigation programmatically
                                            isNavigating = true
                                        }
                                }
                } else {
                    // Show placeholder while loading user
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.gray)
                        .onAppear {
                            print("📌 Waiting for user to load...")
                        }
                }
                
                VStack(alignment: .leading, spacing: 10, content: {(
                    Text("\(self.viewModel.tweet.user) ")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    +
                    Text("@\(self.viewModel.tweet.username)")
                        .foregroundColor(.gray)
                    )
                    
                    Text(self.viewModel.tweet.text)
                        .frame(maxHeight: 100, alignment: .top)
                    
                    /*
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
                     */
                    
                    if let imageId = self.viewModel.tweet.id as String? {
                        if viewModel.tweet.image == "true"{
                            GeometryReader{ proxy in
                                KFImage(URL(string: "http://foot-print-api.up.railway.app/tweet/\(imageId)/image"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.frame(in: .global).width, height: 250)
                                    .cornerRadius(15)
                            }
                            .frame(height: 250)
                        }
                    }
                    
                    Spacer()
                
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
                    if(self.dislike){
                        self.viewModel.unlike()
                    }
                    else{
                        self.viewModel.like()
                    }
                }, label: {
                    if(self.dislike == false){
                        Image("love").resizable()
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                    else{
                        Image("love").resizable().renderingMode(.template).foregroundColor(.red)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                }).foregroundColor(.gray)
                
                Button(action: {
                    
                }, label: {
                    Image("upload").resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 15)
                }).foregroundColor(.blue)
            })
            .padding(.top, 4)
        }
    }
}

var sampleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."


