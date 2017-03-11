//
//  WeatherView.swift
//  Kagami
//
//  Created by Eric Chang on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit
import TwicketSegmentedControl
import FirebaseDatabase

class WeatherView: UIView, UISearchBarDelegate {
    
    var isSelected: Bool = true
    var isSearchActive: Bool = false
    var database: FIRDatabaseReference!
    let userDefault = UserDefaults.standard

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.database = FIRDatabase.database().reference().child("weather")
        self.backgroundColor = ColorPalette.whiteColor
        self.alpha = 0.8
        self.layer.cornerRadius = 9
        searchBar.delegate = self
        setupHierarchy()
//        setupBlurEffect()
        configureConstraints()
        loadUserDefaults()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(degreeLabel)
        self.addSubview(locationLabel)
        self.addSubview(weatherIcon)
        self.addSubview(segmentView)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        segmentView.addSubview(customSegmentControl)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(50)
            view.width.equalToSuperview().multipliedBy(0.60)
            view.height.equalTo(40)
        }
        
        degreeLabel.snp.makeConstraints { (label) in
            label.centerX.equalToSuperview()
            label.top.equalTo(searchBar.snp.bottom).offset(20)
        }
        
        locationLabel.snp.makeConstraints { (label) in
            label.centerX.equalToSuperview()
            label.top.equalTo(degreeLabel.snp.bottom).offset(10)
        }
        
        weatherIcon.snp.makeConstraints { (view) in
            view.top.equalTo(locationLabel.snp.bottom).offset(20)
            view.centerX.equalToSuperview()
        }
        
        segmentView.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(weatherIcon.snp.bottom).offset(20)
            view.height.equalTo(40)
            view.width.equalTo(370)
        }
        
        customSegmentControl.snp.makeConstraints { (control) in
            control.top.bottom.equalToSuperview()
            control.left.equalToSuperview().offset(130.0)
            control.right.equalToSuperview().inset(130.0)
        }
        
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
    }
    
    // MARK: - Methods
    
//    func setupBlurEffect() {
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blur)
//        blurEffectView.frame = self.bounds
//        backgroundImage.addSubview(blurEffectView)
//    }
    
    func addToMirror() {
        print("adding to mirror")
    }
    
    func cancelTapped() {
        print("return to home page")
    }
    
    func loadUserDefaults() {
        if userDefault.object(forKey: "fahrenheit") != nil {
            let isFahrenheit = userDefault.object(forKey: "fahrenheit") as! Bool
            if isFahrenheit {
                customSegmentControl.move(to: 0)
            } else {
                customSegmentControl.move(to: 1)
            }
        }
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("did begin")
        isSearchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("did end")
        isSearchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        database.child("location").setValue(searchBar.text)
        print("search")
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
    
    // MARK: - Lazy Instances
    
    lazy var weatherIcon: UIImageView = {
        let image = UIImage(named: "Partly Cloudy Day-96")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "New York"
        label.font = UIFont(name: "Code-Pro-Demo", size: 20)
        return label
    }()
    
    lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "69℉"
        label.font = UIFont(name: "Code-Pro-Demo", size: 60)
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "ENTER ZIPCODE"
        bar.tintColor = UIColor.white
        bar.barTintColor = ColorPalette.whiteColor
        bar.backgroundColor = UIColor.clear
        bar.searchBarStyle = UISearchBarStyle.default
        bar.layer.cornerRadius = 20
        bar.layer.borderWidth = 1
        bar.layer.borderColor = ColorPalette.grayColor.cgColor
        bar.clipsToBounds = true
        return bar
    }()
    
    lazy var customSegmentControl: TwicketSegmentedControl = {
        let segmentedControl = TwicketSegmentedControl()
        let titles = ["℉", "℃"]
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.highlightTextColor = ColorPalette.whiteColor
        segmentedControl.sliderBackgroundColor = ColorPalette.accentColor
        segmentedControl.isSliderShadowHidden = false
        return segmentedControl
    }()
    
    lazy var segmentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Ok-104")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Cancel-104")
        button.setImage(image, for: .normal)
        return button
    }()
}

extension WeatherView: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        print("Selected index at: \(segmentIndex)!")
        if segmentIndex == 0 {
            database.child("fahrenheit").setValue(true)
            userDefault.setValue(true, forKey: "fahrenheit")
            print("switch to fahrenheit and setting user default to true")
        } else {
            database.child("fahrenheit").setValue(false)
            userDefault.setValue(false, forKey: "fahrenheit")
            print("Switch to celsius and setting user default to false")
        }
    }
}
