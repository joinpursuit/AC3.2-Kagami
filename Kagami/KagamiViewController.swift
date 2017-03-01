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
        
        self.title = "か が み"
        
        setupViewHierarchy()
        addTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        configureConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
>>>>>>> 2df8ddbaa3693dd82c0a5fb8a7386af93e401a1d
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    // view hierarchy
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        view.addSubview(hamburger)
        view.addSubview(kagamiView)
        view.addSubview(annieButton)
        
        hamburger.addSubview(hamburgerBar1)
        
        kagamiView.addSubview(topLeftSelection)
        kagamiView.addSubview(topRightSelection)
        kagamiView.addSubview(middleSelection)
        kagamiView.addSubview(bottomSelection)
    }
    
    // constraints
    func configureConstraints() {
        // mirror view
        kagamiView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(44.0)
            make.centerX.equalToSuperview()
        }
        
        // selections
        topLeftSelection.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(16.0)
            make.width.equalToSuperview().multipliedBy(0.30)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        topRightSelection.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview().inset(16.0)
            make.width.equalToSuperview().multipliedBy(0.30)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        middleSelection.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.5)
        }
        
        bottomSelection.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(16.0)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        annieButton.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(50.0)
            make.width.equalTo(100.0)
        }
    }
    
    // add targets
    func addTargets() {
        annieButton.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        topLeftSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        topRightSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        middleSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        bottomSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
    }
    
    func annieSegue() {
        navigationController?.pushViewController(SelectionViewController(), animated: true)
        
        let backItem = UIBarButtonItem()
        backItem.tintColor = ColorPalette.whiteColor
        navigationController?.navigationBar.tintColor = ColorPalette.whiteColor
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: - Lazy Instantiates
    // hamburger
    lazy var hamburger: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var hamburgerBar1: UIView = {
       let view = UIView()
        return view
    }()
    
    // kagami view
    lazy var kagamiView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.whiteColor
        view.layer.borderColor = ColorPalette.accentColor.cgColor
        view.layer.borderWidth = 1.0
        view.alpha = 0.8
        return view
    }()
    
    // selections
    lazy var topLeftSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    lazy var topRightSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    lazy var middleSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    lazy var bottomSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    // Developer testing button
    lazy var annieButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annie-chan", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
}

