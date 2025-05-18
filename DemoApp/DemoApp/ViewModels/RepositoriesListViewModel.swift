//
//  RepositoriesListViewModel.swift
//  DemoApp
//
//  Created by Moin Rajput on 06/10/2021.
//

import Foundation

class RepositoriesListViewModel {
    
    // MARK: Properties
    private var repositories: [Repository] = []
    private var currentPage = 1
    private var total = 0
    private var dataFectchInProgress = false
    let service: GithubRepositoryServiceProtocol
    let request: RepositoryRequest
    var itemsPerPage = 100
    var reloadTableViewCompletion: (([IndexPath]?) -> Void)?
    var fetchFailedCompletion: (() -> Void)?
    var apiRequestDidFail = false
    
    var isDataFetchInProgress: Bool {
        return dataFectchInProgress
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return repositories.count
    }
    
    // MARK: Init
    init(service: GithubRepositoryServiceProtocol = GithubRepoistoryService()) {
        self.request = RepositoryRequest.createRequest()
        self.service = service
    }
    
    // MARK: Methods
    func repository(at index: Int) -> Repository {
        return repositories[index]
    }
    
    func resetRepositoryData() {
        repositories.removeAll()
        currentPage = 1
        total = 0
    }
    
    func fetchRepositories() {
        guard !dataFectchInProgress else {
            return
        }
        
        dataFectchInProgress = true
        self.apiRequestDidFail = false
        
        service.searchRepository(with: self.request, for: currentPage, itemsPerPage: itemsPerPage) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                print("API failed due to error: \(error)")
                
                DispatchQueue.main.async {
                    self.apiRequestDidFail = true
                    self.dataFectchInProgress = false
                    self.fetchFailedCompletion?()
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.dataFectchInProgress = false
                    
                    self.total = response.totalCount
                    self.repositories.append(contentsOf: response.repositories)
                    
                    if self.currentPage > 2 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.repositories)
                        self.reloadTableViewCompletion?(indexPathsToReload)
                        
                    } else {
                        self.reloadTableViewCompletion?(.none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newRepositories: [Repository]) -> [IndexPath] {
        let startIndex = repositories.count - newRepositories.count
        let endIndex = startIndex + newRepositories.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
