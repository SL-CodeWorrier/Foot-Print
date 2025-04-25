//
//  User.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-23.
//

import Foundation

struct ApiResponse: Decodable{
    var user: User
    var token: String
}

struct User: Decodable, Identifiable {
    let id: String // corresponds to _id in MongoDB
    var name: String
    var username: String
    let email: String
    var bio: String?
    var website: String?
    var location: String?
    let followers: [String] // or [User] if needed
    let following: [String] // or [User] if needed
    let avatarExists: Bool
    var isCurrentUser: Bool = false
    var isFollowed: Bool = false
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case username
        case email
        case bio
        case website
        case location
        case followers
        case following
        case avatarExists
        case createdAt
        case updatedAt
    }
}
