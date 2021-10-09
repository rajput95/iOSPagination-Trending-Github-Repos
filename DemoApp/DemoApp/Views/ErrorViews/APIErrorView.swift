//
//  APIErrorView.swift
//  DemoApp
//
//  Created by Moin Rajput on 09/10/2021.
//

import UIKit
import Lottie

protocol APIErrorViewDelegate: class {
    func retryButtonTappedCompletion()
}

class APIErrorView: UIView {
    weak var delegate: APIErrorViewDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lottieView: AnimationView!
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("APIErrorView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        lottieView.loopMode = .loop
    }
    
    // MARK: Actions
    @IBAction func retryButtonTapped(_ sender: Any) {
        delegate?.retryButtonTappedCompletion()
    }
}
