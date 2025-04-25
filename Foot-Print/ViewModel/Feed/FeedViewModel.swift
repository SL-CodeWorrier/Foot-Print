//
//  FeedViewModel.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import Foundation

class FeedViewModel: ObservableObject {
  
  @Published var tweets = [Tweet]()

  init() {
    fetchTweets()
  }

    func fetchTweets() {
      RequestServices.fetchTweets { res in
        switch res {
        case .success(let tweets):
          DispatchQueue.main.async {
            self.tweets = tweets
          }
        case .failure(let error):
          print("❌ Request failed: \(error.localizedDescription)")
        }
      }
    }
}
