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

class WeatherView: UIView, UISearchBarDelegate {
    
    var isSelected: Bool = true
    var isSearchActive: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorPalette.whiteColor//.withAlphaComponent(0.5)
        searchBar.delegate = self
        setupHierarchy()
//        setupBlurEffect()
        configureConstraints()
//        addGestureToRemoveKeyboard()
        
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
//        self.addSubview(cardView)
        self.addSubview(searchBar)
        self.addSubview(degreeLabel)
        self.addSubview(locationLabel)
        self.addSubview(weatherIcon)
        self.addSubview(segmentView)
        self.addSubview(doneButton)
        
        segmentView.addSubview(customSegmentControl)
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
            control.left.equalToSuperview().offset(120.0)
            control.right.equalToSuperview().inset(120.0)
        }
        
        doneButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalToSuperview().inset(30)
            view.size.equalTo(50.0)
        }
    }
    
    // MARK: - Methods
    
//    func setupBlurEffect() {
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blur)
//        blurEffectView.frame = self.bounds
//        backgroundImage.addSubview(blurEffectView)
//    }
    
    func addToMirror(_ sender: UIButton) {
        print("adding to mirror")
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text is changing
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // api call here to search weather by location
        print("search")
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
        print("cancel")
    }
    
//    func addGestureToRemoveKeyboard() {
//        let gesture = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        self.addGestureRecognizer(gesture)
//    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // MARK: - Lazy Instances
    
    lazy var weatherIcon: UIImageView = {
        let image = UIImage(named: "Partly Cloudy Day-96")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var cardView: UIView = {
        let card = UIView()
        card.layer.cornerRadius = 9
        card.backgroundColor = .gray
        return card
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
        button.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        let image = UIImage(named: "Add Filled-50")
        button.setImage(image, for: .normal)
        return button
    }()
}

extension WeatherView: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        print("Selected index at: \(segmentIndex)!")
        if segmentIndex == 0 {
            print("switch to fahrenheight")
        } else {
            print("Switch to celsius")
        }
    }
}
