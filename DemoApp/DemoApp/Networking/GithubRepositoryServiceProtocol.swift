//
//  GithubRepositoryServiceProtocol.swift
//  DemoApp
//
//  Created by Moin Rajput on 08/10/2021.
//

import Foundation

protocol GithubRepositoryServiceProtocol {
    func searchRepository(with request: RepositoryRequest, for page: Int, itemsPerPage: Int, completion: @escaping (Result<PagedRepositoryResponse, APIResponseError>) -> Void)
}
