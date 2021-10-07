//
//  RepositoriesListViewController.swift
//  DemoApp
//
//  Created by Moin Rajput on 06/10/2021.
//

import UIKit

class RepositoriesListViewController: UITableViewController {
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
}
