//
//  RepositoriesListViewController.swift
//  DemoApp
//
//  Created by Moin Rajput on 06/10/2021.
//

import UIKit

class RepositoriesListViewController: UITableViewController {
    
    // MARK: Properties
    var viewModel: RepositoriesListViewModel!
    lazy var spinner = UIActivityIndicatorView(style: .medium)
    lazy var apiErrorView = APIErrorView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 500))
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        initializeViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.fetchRepositories()
        }
    }
    
    // MARK: Methods
    func setupView() {
        apiErrorView.delegate = self
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshRepositoryList), for: .valueChanged)
    }
    
    func initializeViewModel() {
        viewModel = RepositoriesListViewModel()
        initializeCompletionHandlers()
    }
    
    func initializeCompletionHandlers() {
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
        
        viewModel.fetchFailedCompletion = { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.refreshControl?.endRefreshing()
            
            if self.viewModel.currentCount == 0 {
                self.tableView.reloadData()
            }
            
            self.tableView.tableFooterView = self.apiErrorView
            self.apiErrorView.lottieView.play()
            self.tableView.scrollRectToVisible(self.tableView.tableFooterView!.frame, animated: true)
        }
    }
    
    @objc func refreshRepositoryList() {
        viewModel.resetRepositoryData()
        
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
        
        viewModel.fetchRepositories()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.currentCount == 0 && viewModel.apiRequestDidFail {
            return 0
        }
        
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

// MARK: APIErrorView Delegate Methods
extension RepositoriesListViewController: APIErrorViewDelegate {
    func retryButtonTappedCompletion() {
        if viewModel.currentCount > 0 {
            tableView.tableFooterView = spinner
            tableView.tableFooterView!.isHidden = false
        
        } else {
            viewModel.apiRequestDidFail = false
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.fetchRepositories()
        }
    }
}

// MARK: ScrollView Delegate Methods
extension RepositoriesListViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height + 50

        if bottomEdge >= scrollView.contentSize.height &&
            viewModel.currentCount < viewModel.totalCount {

            spinner.startAnimating()

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView!.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.fetchRepositories()
            }
        }
    }
}
