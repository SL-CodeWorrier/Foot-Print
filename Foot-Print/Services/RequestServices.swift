//
//  RequestServices.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-23.
//

import Foundation

public class RequestServices {
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case decodingError
        case unauthorized
        case unknown(String)
    }

    
    public static var requestDomain = ""

    public static func postTweet(text: String, user: String, username: String, userId: String, completion: @escaping (_ result: [String: Any]) -> Void) {

        // Step 1: Validate URL
        guard let url = URL(string: requestDomain) else {
            print("❌ Invalid URL: \(requestDomain)")
            completion(["error": "Invalid URL"])
            return
        }

        // Step 2: Retrieve JWT Token
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken"), !token.isEmpty else {
            print("❌ JWT token not found or empty in UserDefaults")
            completion(["error": "Authentication token missing. Please log in."])
            return
        }

        // Debug: Print token (hide part for safety)
        print("🔐 Using JWT Token (first 10 chars): \(token.prefix(10))...")

        // Step 3: Setup URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken"), !token.isEmpty else {
                        print("❌ JWT token not found or empty in UserDefaults")
                        completion(["error": "Authentication token missing. Please log in."])
                        return
                    }
                    print("🔐 Using JWT Token (first 10 chars): \(token.prefix(10))...")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Step 4: Create request body
        let body: [String: Any] = [
            "text": text,
            "user": user,
            "username": username,
            "userId": userId
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("📤 Sending tweet with body: \(body)")
        } catch {
            print("❌ Failed to encode request body: \(error.localizedDescription)")
            completion(["error": "Invalid request body"])
            return
        }

        // Step 5: Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Handle network error
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(["error": error.localizedDescription])
                return
            }

            // Handle HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("📬 HTTP Status Code: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 401 {
                    print("🔒 Unauthorized: Token invalid or expired.")
                    
                    if let data = data, let body = String(data: data, encoding: .utf8) {
                        print("🪵 Server response body: \(body)")
                    }

                    completion(["error": "Authentication failed. Please log in again."])
                    return
                }

                if !(200...299).contains(httpResponse.statusCode) {
                    print("⚠️ Unexpected status code: \(httpResponse.statusCode)")
                    completion(["error": "Unexpected server response: \(httpResponse.statusCode)"])
                    return
                }
            }

            // Handle response data
            guard let data = data else {
                print("❌ No data received from server.")
                completion(["error": "No response data"])
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("✅ Success. Response JSON: \(json)")
                    completion(json)
                } else {
                    print("⚠️ Unable to parse response as JSON.")
                    completion(["error": "Invalid JSON format"])
                }
            } catch {
                print("❌ JSON decode error: \(error.localizedDescription)")
                completion(["error": error.localizedDescription])
            }
        }

        task.resume()
    }
    
    static func fetchTweets(completion: @escaping (_ result: Result<[Tweet], NetworkError>) -> Void) {
        guard let url = URL(string: "https://foot-print-api.up.railway.app/tweets") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken"), !token.isEmpty else {
            print("❌ JWT token not found or empty in UserDefaults")
            return
        }
        
        print("🔐 Using JWT Token (first 10 chars): \(token.prefix(10))...")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Request failed with error: \(error.localizedDescription)")
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 HTTP Status Code: \(httpResponse.statusCode)")
                print("📬 Response Headers: \(httpResponse.allHeaderFields)")
            }

            guard let data = data else {
                print("❌ No data received")
                completion(.failure(.requestFailed))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Raw JSON Response:\n\(jsonString)")
            } else {
                print("⚠️ Couldn't convert response data to string")
            }

            switch (response as? HTTPURLResponse)?.statusCode {
            case 200:
                do {
                    let tweets = try JSONDecoder().decode([Tweet].self, from: data)
                    print("✅ Decoded \(tweets.count) tweets in fetchTweets")
                    completion(.success(tweets))
                } catch {
                    print("❌ JSON decoding error: \(error.localizedDescription)")
                    completion(.failure(.decodingError))
                }

            case 401:
                print("🚫 Unauthorized - invalid or expired token")
                completion(.failure(.unauthorized))

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("❌ Unexpected server response: \(message)")
                completion(.failure(.unknown(message)))
            }

        }.resume()
    }
    
    static func fetchTweetsByCurrentUser(completion: @escaping (_ result: Result<[Tweet], NetworkError>) -> Void) {
        guard let url = URL(string: "https://foot-print-api.up.railway.app/tweets/me") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken"), !token.isEmpty else {
            print("❌ JWT token not found or empty in UserDefaults")
            return
        }

        print("🔐 Using JWT Token (first 10 chars): \(token.prefix(10))...")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Request failed with error: \(error.localizedDescription)")
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 HTTP Status Code: \(httpResponse.statusCode)")
                print("📬 Response Headers: \(httpResponse.allHeaderFields)")
            }

            guard let data = data else {
                print("❌ No data received")
                completion(.failure(.requestFailed))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Raw JSON Response:\n\(jsonString)")
            } else {
                print("⚠️ Couldn't convert response data to string")
            }

            switch (response as? HTTPURLResponse)?.statusCode {
            case 200:
                do {
                    let tweets = try JSONDecoder().decode([Tweet].self, from: data)
                    print("✅ Decoded \(tweets.count) tweets in fetchTweetsByCurrentUser")
                    completion(.success(tweets))
                } catch {
                    print("❌ JSON decoding error: \(error.localizedDescription)")
                    completion(.failure(.decodingError))
                }

            case 401:
                print("🚫 Unauthorized - invalid or expired token")
                completion(.failure(.unauthorized))

            case 404:
                print("🫥 No tweets found for this user")
                completion(.success([])) // Return an empty array on 404

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("❌ Unexpected server response: \(message)")
                completion(.failure(.unknown(message)))
            }

        }.resume()
    }
    
    static func fetchUserByTweetId(tweetId: String, completion: @escaping (_ result: Result<User, NetworkError>) -> Void) {
        // Construct the URL with the tweetId
        guard let url = URL(string: "https://foot-print-api.up.railway.app/tweets/user/\(tweetId)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Retrieve JWT token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken"), !token.isEmpty else {
            print("❌ JWT token not found or empty in UserDefaults")
            return
        }

        print("🔐 Using JWT Token (first 10 chars): \(token.prefix(10))...")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in

            // Handle network error
            if let error = error {
                print("❌ Request failed with error: \(error.localizedDescription)")
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }

            // Check the HTTP status code and headers
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 HTTP Status Code: \(httpResponse.statusCode)")
                print("📬 Response Headers: \(httpResponse.allHeaderFields)")
            }

            // Ensure there is data in the response
            guard let data = data else {
                print("❌ No data received")
                completion(.failure(.requestFailed))
                return
            }

            // Log the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Raw JSON Response:\n\(jsonString)")
            } else {
                print("⚠️ Couldn't convert response data to string")
            }

            // Handle the response based on status code
            switch (response as? HTTPURLResponse)?.statusCode {
            case 200:
                do {
                    // Attempt to decode the response into a User object
                    let user = try JSONDecoder().decode(User.self, from: data)
                    print("✅ Decoded user for tweetId \(tweetId)")
                    completion(.success(user))
                } catch {
                    print("❌ JSON decoding error: \(error.localizedDescription)")
                    completion(.failure(.decodingError))
                }

            case 401:
                print("🚫 Unauthorized - invalid or expired token")
                completion(.failure(.unauthorized))

            case 404:
                print("🫥 User not found for tweetId \(tweetId)")
                completion(.failure(.decodingError)) // Return an error for 404

            default:
                // Handle unexpected server responses
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("❌ Unexpected server response: \(message)")
                completion(.failure(.unknown(message)))
            }

        }.resume()
    }
    
    public static func followingProcess(id: String, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("🚀 Starting \(path) process for user ID: \(id)")
        
        guard let url = URL(string: "https://foot-print-api.up.railway.app/user/\(id)/\(path)") else {
            print("❌ Invalid URL")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = UserDefaults.standard.string(forKey: "jsonwebtoken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ No token found")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No auth token found"])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                if let data = data, let message = String(data: data, encoding: .utf8) {
                    completion(.success(message))
                } else {
                    completion(.success("Success"))
                }
            } else {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: responseString])))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            }
        }.resume()
    }
    
    public static func likeOrUnlikeTweet(id: String, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Create the endpoint URL
        guard let url = URL(string: "https://foot-print-api.up.railway.app/tweet/\(id)/\(path)") else {
            print("❌ Invalid like tweet URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = path == "like" ? "POST" : "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Get JWT token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken"), !token.isEmpty else {
            print("❌ JWT token not found")
            completion(.failure(NetworkError.unauthorized))
            return
        }

        // Add token to Authorization header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("👍 Sending like request to tweet ID: \(id)")

        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error sending like request: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 HTTP Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("❌ No data received from server")
                completion(.failure(NetworkError.requestFailed))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Server Response: \(responseString)")
            }

            switch (response as? HTTPURLResponse)?.statusCode {
            case 200:
                completion(.success("Tweet \(path) successfully"))
            case 400:
                completion(.failure(NetworkError.unknown("You have already \(path) this tweet")))
            case 404:
                completion(.failure(NetworkError.unknown("Tweet not found")))
            case 401:
                completion(.failure(NetworkError.unauthorized))
            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("❌ Unexpected server response: \(message)")
                completion(.failure(NetworkError.unknown(message)))
            }
        }.resume()
    }
}
