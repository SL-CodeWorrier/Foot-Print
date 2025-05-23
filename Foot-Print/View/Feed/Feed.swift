//
//  Feed.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-03-15.
//

import SwiftUI

struct Feed: View {
    
    @ObservedObject var viewModel = FeedViewModel();
    
    let user: User;
    var body: some View {
        ScrollView(.vertical, showsIndicators: false,
                   content: {
            LazyVStack(spacing: 18) {
                
                /*
                postCaptionCellView(postCaption: "Hey guys, I'm planning a solo hike in the mountains this weekend. #Hiking #SoloHiking", postImage: "post")
                
                Divider()
                
                ForEach(1...20, id: \.self) { _ in
                    postCaptionCellView(postCaption: sampleText)
                    Divider()
                }*/
                
                ForEach(viewModel.tweets) { tweet in
                    //postCaptionCellView(postCaption: tweet.text);
                    postCaptionCellView(viewModel: TweetCellViewModel(tweet: tweet, currentUser: user))
                    Divider()
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .zIndex(0)
        })
    }
}
