//
//  RepositoriesListViewController.swift
//  DemoApp
//
//  Created by Moin Rajput on 06/10/2021.
//

import UIKit
import SDWebImage

class RepositoriesListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    // MARK: Properties
    var viewModel: RepositoriesListViewModel!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        //tableView.prefetchDataSource = self
        viewModel = RepositoriesListViewModel()
        
        viewModel.fetchRepositories()
        
        viewModel.reloadTableViewCompletion = { [weak self ] indexPaths in
            guard let self = self else {
                return
            }
            
            if indexPaths != nil {
                let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: indexPaths!)
                self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            
            } else {
                self.tableView.reloadData()
            }
        }
        
        viewModel.fetchFailedCompletion = { [weak self] failureReason in
            guard let self = self else {
                return
            }
            
            print("error received in api call")
        }
    }
    
    // MARK: Methods
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
    
    // MARK: UITableViewDataSourcePrefetching Methods
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      if indexPaths.contains(where: isLoadingCell) {
        viewModel.fetchRepositories()
      }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.totalCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
          cell.configure(for: .none)
        
        } else {
          cell.configure(for: viewModel.repository(at: indexPath.row))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
}
