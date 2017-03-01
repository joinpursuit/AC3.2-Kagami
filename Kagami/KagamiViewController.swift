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
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        view.addSubview(kagamiView)
        view.addSubview(annieButton)
        
        annieButton.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
    }
    
    func configureConstraints() {
        kagamiView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(44.0)
            make.centerX.equalToSuperview()
        }
        
        annieButton.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.height.equalTo(50.0)
            make.width.equalTo(100.0)
        }
    }
    
    func annieSegue() {
        navigationController?.pushViewController(SelectionViewController(), animated: true)
    }
    
    // MARK: - Lazy Instantiates
    lazy var kagamiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1.0
        view.alpha = 0.8
        return view
    }()
    
    // Developer testing button
    lazy var annieButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annie-chan", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
}
