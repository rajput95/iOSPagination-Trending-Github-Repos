//
//  RepositoryOwner.swift
//  DemoApp
//
//  Created by Moin Rajput on 10/10/2021.
//

import Foundation

struct RepositoryOwner: Codable {
    let username: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case avatarURL = "avatar_url"
    }
}
