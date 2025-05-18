//
//  Repository.swift
//  DemoApp
//
//  Created by Moin Rajput on 10/10/2021.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let description: String
    let language: String?
    let owner: RepositoryOwner
    let fullName: String
    let stargazersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case owner
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
    }
}
