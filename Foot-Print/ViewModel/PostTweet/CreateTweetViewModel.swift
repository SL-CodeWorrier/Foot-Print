//
//  CreateTweetViewModel.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-23.
//

import SwiftUI

class CreateTweetViewModel: ObservableObject{
    
    func uploadPost(text: String, image: UIImage?){
        
        guard let user = AuthViewModel.shared.currentUser else {
            return;
        }
        
        RequestServices.requestDomain = "https://foot-print-api.up.railway.app/tweets";
        RequestServices.postTweet(text: text, user: user.name, username: user.username, userId: user.id) { result in
            print(text);print(user.name);print(user.username);print(user.id);
            
            if let image = image {
                            if let tweet = result["tweet"] as? [String: Any],
                               let id = tweet["_id"] as? String {
                                ImageUploader.uploadImage(paramName: "image", fileName: "image1", image: image, urlPath: "uploadTweetImage/\(id)")
                                print("id is \(id)");
                            } else {
                                print("❌ Could not find tweet ID in server response.")
                            }
                        }
            
            DispatchQueue.main.async {
                    if let error = result["error"] as? String {
                        print("❌ Tweet failed: \(error)")
                    } else {
                        print("🎉 Tweet posted successfully: \(result)")
                    }
                }
        }
    }
}
