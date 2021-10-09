//
//  GithubRepositoryService.swift
//  DemoApp
//
//  Created by Moin Rajput on 08/10/2021.
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

struct RepositoryOwner: Codable {
    let username: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case avatarURL = "avatar_url"
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}

class GithubRepoistoryService: GithubRepositoryServiceProtocol {
    // MARK: Properties
    private var baseURL = URL(string: "https://api.github.com/")!
    let session: URLSession
    
    // MARK: Init
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Methods
    func searchRepository(with request: RepositoryRequest,
                          for page: Int, itemsPerPage: Int = 100,
                          completion: @escaping (Result<PagedRepositoryResponse, APIResponseError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        let parameters = ["page": "\(page)", "per_page": "\(itemsPerPage)"].merging(request.parameters, uniquingKeysWith: +)
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.hasSuccessStatusCode, let data = data
            else {
                completion(Result.failure(APIResponseError.network))
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(PagedRepositoryResponse.self, from: data) else {
                completion(Result.failure(APIResponseError.decoding))
                return
            }
            
            completion(Result.success(decodedResponse))
        }).resume()
        
    }
}

struct RepositoryRequest {
    var path: String {
        return "search/repositories"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
    
    static func createRequest() -> RepositoryRequest {
        let parameters = ["q": "language=+sort:stars"]
        return RepositoryRequest(parameters: parameters)
    }
}
