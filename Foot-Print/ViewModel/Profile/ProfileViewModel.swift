//
//  ProfileViewModel.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var tweets = [Tweet]()
    
    init(user: User) {
        self.user = user
        fetchTweets()
        checkIfUserIsCurrentUser()
        checkIfUserIsFollowed()
    }
    
    func fetchTweets() {
        RequestServices.fetchTweetsByCurrentUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tweets):
                    self.tweets = tweets
                case .failure(let error):
                    print("❌ Failed to fetch user tweets: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUserByTweetId(tweetId: String) {
            RequestServices.fetchUserByTweetId(tweetId: tweetId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        // Update the user model with the fetched user data
                        self.user = user
                        print("✅ Successfully fetched user: \(user.username)")
                    case .failure(let error):
                        print("❌ Failed to fetch user by tweetId: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    func checkIfUserIsCurrentUser(){
        if(self.user.id == AuthViewModel.shared.currentUser?.id){
            self.user.isCurrentUser = true
        }
    }
    
    func follow() {
        
        RequestServices.followingProcess(id: self.user.id, path: "follow") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("✅ Followed: \(message)")
                    self.user.isFollowed = true
                    //self.user?.followers.append("currentUserId") // optionally update followers
                    // Or update isFollowing = true
                case .failure(let error):
                    print("❌ Follow error: \(error.localizedDescription)")
                }
            }
        }
    }

    func unfollow() {
        
        RequestServices.followingProcess(id: self.user.id, path: "unfollow") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.user.isFollowed = false
                    print("✅ Unfollowed: \(message)")
                    //self.user?.followers.removeAll { $0 == "currentUserId" } // remove follower
                    // Or update isFollowing = false
                case .failure(let error):
                    print("❌ Unfollow error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func checkIfUserIsFollowed(){
        if(self.user.followers.contains(AuthViewModel.shared.currentUser!.id)){
            self.user.isFollowed = true
        }
        else{
            self.user.isFollowed = false
        }
    }
}
