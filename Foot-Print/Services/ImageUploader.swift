//
//  ImageUploader.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import SwiftUI

struct ImageUploader {
    static func uploadImage(paramName: String, fileName: String, image: UIImage, urlPath: String) {
        
        print("📤 Now in uploadImage func");

        guard let url = URL(string: "https://foot-print-api.up.railway.app/\(urlPath)") else {
            print("❌ Invalid URL");
            return;
        }

        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        if let token = UserDefaults.standard.string(forKey: "jsonwebtoken") {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Multipart body construction
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName).png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send request
        URLSession.shared.uploadTask(with: urlRequest, from: data) { responseData, response, error in
            if let error = error {
                print("❌ Upload error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return
            }
            
            print("📡 Status Code: \(httpResponse.statusCode)")
            
            if let data = responseData {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("✅ Upload response JSON: \(json)")
                } catch {
                    print("❌ JSON Parsing error: \(error.localizedDescription)")
                }
            } else {
                print("❌ No data received from upload")
            }
        }.resume()
    }
}
