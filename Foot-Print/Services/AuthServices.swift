//
//  AuthServices.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-23.
//

import Foundation
import SwiftUI

public class AuthServices {
    
    struct RegisterResponse: Decodable {
        let message: String
        let user: User
    }
    
    struct LoginResponse: Decodable {
            let message: String
            let token: String
            let user: User
        }
    
    enum NetworkError: Error {
        case invalidUrl
        case noData
        case decodingError
        case unknown
    }
    
    enum AuthenticationError: Error {
        case invalidCredentials
        case custom(errorMessage: String)
    }
    
    static func login(email: String, password: String, completion: @escaping (Result<Data?, AuthenticationError>) -> Void) {
        
        print("🔐 Starting login process...")
        print("📧 Email: \(email)")
        print("🔑 Password: \(password)")
        
        guard let url = URL(string: "https://foot-print-api.up.railway.app/users/login") else {
            print("❌ Invalid URL")
            completion(.failure(.custom(errorMessage: "Invalid URL")))
            return
        }
        
        print("🌍 Login endpoint: \(url.absoluteString)")
        
        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        print("📦 Request body to be sent: \(requestBody)")
        
        makeRequest(urlString: url, reqBody: requestBody) { result in
            switch result {
            case .success(let data):
                print("✅ Login request successful.")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("📨 Server Response: \(responseString)")
                } else {
                    print("⚠️ Login succeeded but response data is nil or not decodable to string.")
                }
                completion(.success(data))
                
            case .failure(let error):
                
                switch error {
                case .noData:
                    completion(.failure(.invalidCredentials))
                default:
                    print("⚠️ Custom error: \(error.localizedDescription)")
                    completion(.failure(.custom(errorMessage: "Login failed: \(error.localizedDescription)")))
                }
            }
        }
    }
    
    static func register(email: String, username: String, password: String, name: String, completion: @escaping (Result<Data?, AuthenticationError>) -> Void) {
        
        print("Register function called.")
        
        let reqBody: [String: Any] = [
            "email": email,
            "username": username,
            "password": password,
            "name": name
        ]
        
        // Convert the request body dictionary to JSON string for printing
        if let jsonData = try? JSONSerialization.data(withJSONObject: reqBody, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request Body: \(jsonString)")
        } else {
            print("Failed to serialize request body to JSON.")
        }
        
        guard let url = URL(string: "https://foot-print-api.up.railway.app/user") else {
            print("Invalid URL.")
            completion(.failure(.custom(errorMessage: "Invalid URL.")))
            return
        }
        
        print("URL formed successfully.")
        
        makeRequest(urlString: url, reqBody: reqBody) { result in
            switch result {
            case .success(let data):
                print("Request successful, data received.")
                completion(.success(data))
            case .failure(let error):
                print("Request failed with error: \(error)")
                switch error {
                case .invalidUrl:
                    print("Invalid URL error.")
                    completion(.failure(.custom(errorMessage: "Invalid URL.")))
                case .noData:
                    print("No data received error.")
                    completion(.failure(.custom(errorMessage: "No data received or invalid credentials.")))
                case .decodingError:
                    print("Decoding error.")
                    completion(.failure(.custom(errorMessage: "Error decoding data.")))
                case .unknown:
                    print("Unknown error occurred.")
                    completion(.failure(.custom(errorMessage: "An unknown error occurred.")))
                }
            }
        }
    }
    
    static func fetchUser(id: String, completion: @escaping (Result<Data?, AuthenticationError>) -> Void) {
        print("🔍 Starting fetch user process...")
        print("🆔 User ID: \(id)")
        
        guard let url = URL(string: "https://foot-print-api.up.railway.app/user/\(id)") else {
            print("❌ Invalid URL for fetching user.")
            completion(.failure(.custom(errorMessage: "Invalid URL")))
            return
        }
        
        print("🌍 Fetch user endpoint: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Fetch user request failed: \(error.localizedDescription)")
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response.")
                completion(.failure(.custom(errorMessage: "Invalid HTTP response.")))
                return
            }
            
            print("📥 HTTP Status Code: \(httpResponse.statusCode)")
            
            // Check status code for success (2xx)
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 404 {
                    print("🚫 User not found.")
                    completion(.failure(.custom(errorMessage: "User not found.")))
                } else {
                    print("⚠️ Unexpected status code: \(httpResponse.statusCode)")
                    completion(.failure(.custom(errorMessage: "Unexpected status code")))
                }
                return
            }
            
            if let data = data {
                // Log only the response body as a string for debugging purposes
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📨 Server Response Body: \(responseString)")
                } else {
                    print("⚠️ Unable to decode data to a readable format.")
                }
                completion(.success(data))
            } else {
                print("⚠️ No data received from server.")
                completion(.failure(.custom(errorMessage: "No data received from server")))
            }
        }
        
        task.resume()
    }
    
    static func makeRequest(urlString: URL, reqBody: [String: Any], completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        
        print("Making request to URL: \(urlString)")
        
        let session = URLSession.shared;
        var request = URLRequest(url: urlString);
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: [])
            print("Request body serialized successfully.")
        } catch {
            print("Error serializing request body.")
            completion(.failure(.decodingError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                print("Network error occurred.")
                completion(.failure(.unknown))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response from server.")
                completion(.failure(.unknown))
                return
            }
            
            // ✅ Print the full response body for all responses
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body from Server:\n\(responseBody)")
            } else {
                print("No response body or failed to decode response body.")
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response status code: \(httpResponse.statusCode), expected 2xx.")
                completion(.failure(.noData))
                return
            }

            print("HTTP request successful with status code: \(httpResponse.statusCode)")
            completion(.success(data)) // Return raw Data? here
        }.resume()
    }
    
    static func makePatchRequestWithAuth(urlString: URL, reqBody: [String: Any], completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let token = UserDefaults.standard.string(forKey: "jsonwebtoken") ?? ""
        
        print("🛠 PATCH Request with Auth started...")
        print("📍 URL: \(urlString)")
        print("🛡 Token: \(token)")
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "PATCH"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: [])
            print("📦 PATCH Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "Invalid JSON")")
        } catch {
            print("❌ Failed to serialize request body.")
            completion(.failure(.decodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error occurred: \(error.localizedDescription)")
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response.")
                completion(.failure(.unknown))
                return
            }
            
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("📨 PATCH Server Response: \(responseBody)")
            } else {
                print("⚠️ No data received or couldn't decode response body.")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("⚠️ Unexpected status code: \(httpResponse.statusCode)")
                completion(.failure(.noData))
                return
            }
            
            print("✅ PATCH request successful.")
            completion(.success(data ?? Data()))
            
        }.resume()
    }
}
