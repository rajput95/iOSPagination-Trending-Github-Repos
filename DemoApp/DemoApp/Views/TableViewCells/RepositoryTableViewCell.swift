//
//  RepositoryTableViewCell.swift
//  DemoApp
//
//  Created by Moin Rajput on 07/10/2021.
//

import UIKit
import SDWebImage
import SkeletonView

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: Properties
    var isExpandedViewHidden: Bool {
        return cellExpandedView.isHidden
    }
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet weak var cellBasicView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
   
    @IBOutlet weak var cellExpandedView: UIView!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var stargazersCount: UILabel!
    
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
    
    func configure(for repository: Repository?) {
        if let repository = repository {
            cellBasicView.hideSkeleton()
            
            if let imageURL = URL(string: repository.owner.avatarURL) {
                avatarImageView.sd_setImage(with: imageURL)
            }
            
            username.text = repository.owner.username
            repositoryName.text = repository.fullName
            
            repositoryDescription.text = repository.description
            repositoryDescription.isHidden = false
            
           // language = repository.owner.l
            stargazersCount.text = "\(repository.stargazersCount)"
            
        } else {
            repositoryDescription.isHidden = true
            cellBasicView.showAnimatedGradientSkeleton()
        }
    }
    
    func showDetailView() {
        cellExpandedView.isHidden = false
    }
    
    func hideDetailView() {
        cellExpandedView.isHidden = true
    }
}
