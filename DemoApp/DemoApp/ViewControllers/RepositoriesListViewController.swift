//
//  RepositoriesListViewController.swift
//  DemoApp
//
//  Created by Moin Rajput on 06/10/2021.
//

import UIKit
import SDWebImage
import Lottie

class RepositoriesListViewController: UITableViewController {
    
    // MARK: Properties
    var viewModel: RepositoriesListViewModel!
    let spinner = UIActivityIndicatorView(style: .medium)
  
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkMarkAnimation =  AnimationView(name: "retry-and-user-busy-lottie")
        self.tableView.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = self.tableView.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
        
               initializeViewModel()
//        setupView()

//        viewModel.fetchRepositories()
    }
    
    // MARK: Methods
    func initializeViewModel() {
        viewModel = RepositoriesListViewModel()
        
        viewModel.reloadTableViewCompletion = { [weak self ] indexPaths in
            guard let self = self else {
                return
            }
            
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.tableFooterView?.isHidden = true
            
            if indexPaths != nil {
                self.tableView.insertRows(at: indexPaths!, with: .bottom)
            } else {
                self.tableView.reloadData()
            }
        }
        
        viewModel.fetchFailedCompletion = { [weak self] failureReason in
            guard let self = self else {
                return
            }
            
            self.tableView.tableFooterView?.isHidden = true
            self.tableView.refreshControl?.endRefreshing()
            
            print("error received in api call")
        }
    }
    
    func setupView() {
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshRepositoryList), for: .valueChanged)
    }
    
    @objc func refreshRepositoryList() {
        viewModel.refreshRepositoryData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        viewModel.fetchRepositories()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCount == 0 ? viewModel.itemsPerPage : viewModel.currentCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.isUserInteractionEnabled = false
            cell.configure(for: .none)
            
        } else {
            cell.isUserInteractionEnabled = true
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

// MARK: ScrollView Delegate Methods
//extension RepositoriesListViewController {
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
//
//        if bottomEdge >= scrollView.contentSize.height &&
//            !viewModel.isFetchInProgress &&
//            viewModel.currentCount < viewModel.totalCount {
//
//            spinner.startAnimating()
//
//            self.tableView.tableFooterView = spinner
//            self.tableView.tableFooterView?.isHidden = false
//
//            viewModel.fetchRepositories()
//        }
//
//    }
//}
