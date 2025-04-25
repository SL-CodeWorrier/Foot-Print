//
//  TweetCellViewModel.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import SwiftUI

class TweetCellViewModel: ObservableObject {
    @Published var tweet: Tweet
    @Published var user: User?
    
    let currentUser: User
    
    init(tweet: Tweet, currentUser: User) {
        self.tweet = tweet
        self.currentUser = currentUser
        self.fetchUser(userId: tweet.userId)
        checkIfUserLikePost()
    }
    
    func fetchUser(userId: String) {
        print("Fetching user for userId: \(userId)") // Debugging line
        AuthServices.fetchUser(id: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let data = data else {
                        print("⚠️ No data to decode.")
                        return
                    }

                    do {
                        let decodedUser = try JSONDecoder().decode(User.self, from: data)
                        self.user = decodedUser
                        print("✅ User decoded and set successfully: \(decodedUser)") // Debugging line
                    } catch {
                        print("❌ Failed to decode user: \(error.localizedDescription)")
                    }

                case .failure(let error):
                    print("❌ Error fetching user in func fetchUser in TweetCellViewModel: \(error)") // Debugging line
                }
            }
        }
    }
    
    func like(){
        RequestServices.likeOrUnlikeTweet(id: self.tweet.id, path: "like") { result in
            switch result {
            case .success(let message):
                print("🎉 Success: \(message)")
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
        
        self.tweet.dislike = true
    }
    
    func unlike(){
        RequestServices.likeOrUnlikeTweet(id: self.tweet.id, path: "unlike") { result in
            switch result {
            case .success(let message):
                print("🎉 Success: \(message)")
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
        
        self.tweet.dislike = false
    }
    
    func checkIfUserLikePost(){
        if (self.tweet.likes.contains(self.currentUser.id)){
            self.tweet.dislike = true
        }
        else{
            self.tweet.dislike = false
        }
    }
}
