//
//  AuthViewModel.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-23.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var isauthenticated: Bool = false;
    @Published var currentUser: User?
    
    init(){
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "jsonwebtoken")
        if token != nil {
            self.isauthenticated = true
            if let userId = defaults.object(forKey: "userid") as? String {
                fetchUser(userId: userId);
                print("User fetched!");
            }
        }
        else{
            self.isauthenticated = false;
        }
    }
    
    static let shared = AuthViewModel();
    
    func login(email: String, password: String) {
        
        let defaults = UserDefaults.standard;
        
        AuthServices.login(email: email, password: password) { result in
            switch result {
            case .success(let data):
                guard let responseData = data else {
                    print("⚠️ No data returned from server.")
                    return
                }

                // Decode the login response
                do {
                    let decodedResponse = try JSONDecoder().decode(AuthServices.LoginResponse.self, from: responseData)
                    print("✅ Login successful!")
                    print("User: \(decodedResponse.user)")
                    print("Message: \(decodedResponse.message)")
                    print("Token: \(decodedResponse.token)")
                    
                    DispatchQueue.main.async {
                        defaults.set(decodedResponse.token, forKey: "jsonwebtoken");
                        defaults.set(decodedResponse.user.id, forKey: "userid");
                        self.isauthenticated = true;
                        self.currentUser = decodedResponse.user;
                    }
                    
                } catch {
                    print("❌ Failed to decode login response: \(error.localizedDescription)")
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("Server raw response: \(responseString)")
                    }
                }

            case .failure(let error):
                switch error {
                case .invalidCredentials:
                    print("❌ Invalid credentials provided.")
                case .custom(let errorMessage):
                    print("❌ Error: \(errorMessage)")
                }
            }
        }
    }
    
    func register(name: String, username: String, email: String, password: String) {
            AuthServices.register(email: email, username: username, password: password, name: name) { result in
                switch result {
                case .success(let data): // `data` is of type `Data?`
                    guard let responseData = data else {
                        print("No data returned from server.")
                        return
                    }
                    
                    // Decoding the response data into `RegisterResponse`
                    do {
                        let decodedResponse = try JSONDecoder().decode(AuthServices.RegisterResponse.self, from: responseData)
                        print("✅ Registration successful!")
                        print("User: \(decodedResponse.user)")
                        print("Message: \(decodedResponse.message)")
                        // You can now store the token securely and update app state here
                        // Also, decodedResponse.user contains the user information
                    } catch {
                        print("❌ Failed to decode response: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    switch error {
                    case .invalidCredentials:
                        print("❌ Invalid credentials.")
                    case .custom(let errorMessage):
                        print("❌ Error: \(errorMessage)")
                    }
                }
            }
        }
    
    func fetchUser(userId: String) {
        AuthServices.fetchUser(id: userId) { result in
            switch result {
            case .success(let data):
                guard let responseData = data else {
                    print("⚠️ No user data received.")
                    return
                }
                
                do {
                    let fetchedUser = try JSONDecoder().decode(User.self, from: responseData)
                    DispatchQueue.main.async {
                        UserDefaults.standard.setValue(fetchedUser.id, forKey: "userid")
                        self.currentUser = fetchedUser
                        self.isauthenticated = true
                        print("✅ User fetched successfully: \(fetchedUser)")
                    }
                } catch {
                    print("❌ Failed to decode user data: \(error.localizedDescription)")
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("Server raw response: \(responseString)")
                    }
                }
                
            case .failure(let error):
                switch error {
                case .invalidCredentials:
                    print("❌ Invalid credentials while fetching user.")
                case .custom(let errorMessage):
                    print("❌ Error fetching user: \(errorMessage)")
                }
            }
        }
    }
    
    func logout() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation();
        let userIdKey = "userId"
        defaults.removeObject(forKey: userIdKey);
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        DispatchQueue.main.async {
            self.isauthenticated = false;
        }
    }
    
    func like(){
        
    }
    
    func unlike(){
        
    }
}
