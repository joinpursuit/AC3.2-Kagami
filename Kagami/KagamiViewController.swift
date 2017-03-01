//
//  KagamiViewController.swift
//  Kagami
//
//  Created by Eric Chang on 2/28/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class KagamiViewController: UIViewController {

    // MARK: - Properties

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        configureConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    func setupViewHierarchy() {
        view.backgroundColor = .white
        
        view.addSubview(kagamiView)
    }
    
    func configureConstraints() {
        kagamiView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(44.0)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Lazy Instantiates
    lazy var kagamiView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.borderWidth = 1.0
        view.alpha = 0.8
        return view
    }()
    
}
