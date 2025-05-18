//
//  PagedRepositoryOwner.swift
//  DemoApp
//
//  Created by Moin Rajput on 10/10/2021.
//

import Foundation

struct PagedRepositoryResponse: Codable {
    let repositories: [Repository]
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case repositories = "items"
        case totalCount = "total_count"
    }
}
