//
//  Tweet.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-23.
//

import Foundation

struct Tweet: Identifiable, Codable {
    let id: String
    let text: String
    let user: String
    let username: String
    var likes: [String]
    let userId: String
    let createdAt: String?
    let updatedAt: String?
    let image: String? // Base64 string from backend
    var dislike: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case user
        case username
        case likes
        case userId
        case createdAt
        case updatedAt
        case image
    }
}
