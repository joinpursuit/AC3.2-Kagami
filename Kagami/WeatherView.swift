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
        
        // add subviews
//        self.addSubview(testButton)
//        self.backgroundColor = .red
        
        // configure constraints
//        testButton.snp.makeConstraints { (make) in
//            make.centerX.centerY.equalToSuperview()
//            make.height.width.equalTo(100.0)
//        }
        
        self.backgroundColor = .white
        searchBar.delegate = self
        setupHierarchy()
//        setupBlurEffect()
        setupOverlayView()
        setupConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /*func flashButtonClicked(sender: UIButton) {
        print("Hello World")
        self.removeFromSuperview()
    }
    
    lazy var testButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Hello World"
        button.setImage(#imageLiteral(resourceName: "Flash_Logo_01"), for: .normal)
        button.addTarget(SettingsViewController() , action: #selector(flashButtonClicked(sender:)), for: .touchUpInside)
        return button
    }() */
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(segmentView)
        self.addSubview(cardView)
        self.addSubview(searchBar)
        segmentView.addSubview(customSegmentControl)
    }
    
    func setupOverlayView() {
        // over lay view
        cardView.snp.makeConstraints { (view) in
            view.centerX.centerY.equalToSuperview()
            view.height.equalTo(self).multipliedBy(0.4)
            view.width.equalTo(self).multipliedBy(0.6)
        }
        // label
        cardView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (view) in
            view.top.equalTo(cardView.snp.top).inset(20)
            view.centerX.equalTo(cardView.snp.centerX)
        }
        // icon
        cardView.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints { (view) in
            view.top.equalTo(locationLabel.snp.bottom).offset(10)
            view.centerX.equalTo(cardView.snp.centerX)
        }
        // buttons
        cardView.addSubview(fahrenheitButton)
        fahrenheitButton.snp.makeConstraints { (view) in
            view.top.equalTo(cardView)
            view.trailing.equalTo(cardView).inset(5)
        }
        cardView.addSubview(celsiusButton)
        celsiusButton.snp.makeConstraints { (view) in
            view.top.equalTo(cardView)
            view.trailing.equalTo(fahrenheitButton.snp.leading).inset(5)
        }
    }
    
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            //            view.bottom.equalToSuperview()
            view.top.equalTo(cardView.snp.bottom).offset(30)
            view.width.equalTo(self).multipliedBy(0.60)
            view.height.equalTo(40)
        }
        segmentView.snp.makeConstraints { (view) in
            view.left.right.equalToSuperview()
            view.top.equalTo(self.snp.top).inset(150)
            view.height.equalTo(40)
            view.width.equalTo(370)
        }
        customSegmentControl.snp.makeConstraints { (control) in
            control.top.bottom.equalTo(segmentView)
            control.left.equalTo(segmentView).inset(120)
            control.right.equalTo(segmentView).inset(120)
        }
    }
    
    // MARK: - Methods
    
//    func setupBlurEffect() {
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blur)
//        blurEffectView.frame = self.bounds
//        backgroundImage.addSubview(blurEffectView)
//    }
    
    func switchToFahrenheit() {
        if isSelected {
            print("fahrenheit")
            fahrenheitButton.setTitleColor(.gray, for: .normal)
            isSelected = !isSelected
        }else {
            isSelected = !isSelected
        }
    }
    
    func switchToCelsius() {
        if isSelected {
            print("celsius")
            celsiusButton.setTitleColor(.gray, for: .normal)
            isSelected = !isSelected
        }else {
            isSelected = !isSelected
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // called when text is changing
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // api call here to search weather by location
        print("search")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
        print("cancel")
    }
    
    func addGestureToRemoveKeyboard() {
        let gesture = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(gesture)
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // MARK: - Lazy Instances
    
    lazy var weatherIcon: UIImageView = {
        let image = UIImage(named: "sunny")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
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
        return label
    }()
    
    lazy var fahrenheitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        button.setTitle("℉", for: .normal)
        button.addTarget(self, action: #selector(switchToFahrenheit), for: .touchUpInside)
        button.setTitleColor(ColorPalette.blackColor, for: .normal)
        return button
    }()
    
    lazy var celsiusButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        button.setTitle("℃", for: .normal)
        button.addTarget(self, action: #selector(switchToCelsius), for: .touchUpInside)
        button.setTitleColor(ColorPalette.blackColor, for: .normal)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "ENTER ZIPCODE"
        bar.layer.cornerRadius = 15
        bar.clipsToBounds = true
        bar.searchBarStyle = UISearchBarStyle.prominent
        bar.backgroundColor = ColorPalette.whiteColor
//        bar.barTintColor = ColorPalette.accentColor
        return bar
    }()
    
    lazy var customSegmentControl: TwicketSegmentedControl = {
        let frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: 40)
        let segmentedControl = TwicketSegmentedControl(frame: frame)
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
