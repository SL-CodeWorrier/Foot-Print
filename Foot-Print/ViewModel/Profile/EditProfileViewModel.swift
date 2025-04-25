//
//  EditProfileViewModel.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-25.
//

import SwiftUI

class EditProfileViewModel: ObservableObject{
    
    @Published var uploadComplete: Bool = false
    var user: User;
    
    init(user: User){
        self.user = user
    }
    
    func save(name: String?, bio: String?, website: String?, location: String?){
        
        guard let userNewName = name else { return }
        guard let userNewBio = bio else { return }
        guard let userNewWebsite = website else { return }
        guard let userNewLocation = location else { return }
        
        self.user.name = userNewName
        self.user.bio = userNewBio
        self.user.website = userNewWebsite
        self.user.location = userNewLocation
        
        self.uploadComplete.toggle()
    }
    
    func uploadProfileImage(text: String, image: UIImage?){
        guard let user = AuthViewModel.shared.currentUser else { return }
        let urlPath = "/user/\(user.id)/avatar"
        
        if let image = image{
            ImageUploader.uploadImage(paramName: "avatar", fileName: "image1", image: image, urlPath: urlPath)
        }
    }
    
    func uploadUserData(name: String?, bio: String?, website: String?, location: String?) {
        // Build the request body dynamically from non-nil parameters
        var updatedFields: [String: Any] = [:]
        
        if let name = name { updatedFields["name"] = name }
        if let bio = bio { updatedFields["bio"] = bio }
        if let website = website { updatedFields["website"] = website }
        if let location = location { updatedFields["location"] = location }

        // Retrieve the stored auth token
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ No auth token found.")
            return
        }

        // Create the request URL
        guard let patchURL = URL(string: "https://foot-print-api.up.railway.app/user/\(user.id)") else {
            print("❌ Invalid URL.")
            return
        }

        // Make the PATCH request
        AuthServices.makePatchRequestWithAuth(urlString: patchURL, reqBody: updatedFields) { result in
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.save(name: name, bio: bio, website: website, location: location)
                        self.uploadComplete = true
                    }
                    print("✅ User updated successfully. Response: \(responseString)")
                } else {
                    DispatchQueue.main.async {
                        self.save(name: name, bio: bio, website: website, location: location)
                        self.uploadComplete = true
                    }
                    print("✅ User updated successfully, but couldn't decode response string.")
                }
            case .failure(let error):
                print("❌ Failed to update user: \(error)")
            }
            
            
        }
    }
}
