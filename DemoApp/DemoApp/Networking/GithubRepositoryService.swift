//
//  GithubRepositoryService.swift
//  DemoApp
//
//  Created by Moin Rajput on 08/10/2021.
//

import Foundation

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
        var encodedURLRequest = urlRequest.encode(with: parameters)
        encodedURLRequest.timeoutInterval = 10
        
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
