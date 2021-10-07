//
//  RepositoryTableViewCell.swift
//  DemoApp
//
//  Created by Moin Rajput on 07/10/2021.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: Properties
    var isExpandedViewHidden: Bool {
        return cellExpandedView.isHidden
    }
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var cellExpandedView: UIView!
    @IBOutlet weak var cellBasicView: UIView!
    
    // MARK: View Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isExpandedViewHidden, selected {
            showDetailView()
        } else {
            hideDetailView()
        }
    }
    
    func showDetailView() {
        cellExpandedView.isHidden = false
    }
    
    func hideDetailView() {
        cellExpandedView.isHidden = true
    }
}
