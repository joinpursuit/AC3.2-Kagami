//
//  ForecastView.swift
//  Kagami
//
//  Created by Annie Tung on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseDatabase
import TwicketSegmentedControl

class ForecastView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var isSearchActive: Bool = false
    var database: FIRDatabaseReference!
    var forecast: [Forecast] = []
    var gradientLayer: CAGradientLayer!
    let userDefault = UserDefaults.standard
    // default properties
    var defaultZipcode: String?
    var isFahrenheit: Bool?
    var unit = "imperial"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.database = FIRDatabase.database().reference().child("forecast")
        createGradientLayer()
        self.layer.cornerRadius = 9
        setupHierarchy()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        searchBar.delegate = self
        loadUserDefaults()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(tableView)
        self.addSubview(searchBar)
        self.addSubview(cityLabel)
        self.addSubview(segmentView)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(headerImage)
        segmentView.addSubview(customSegmentControl)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { (view) in
            view.top.left.right.equalToSuperview()
            view.height.equalTo(50)
        }
        headerImage.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(searchBar.snp.bottom)
        }
        cityLabel.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(headerImage.snp.bottom).offset(20)
        }
        tableView.snp.makeConstraints { (view) in
            view.top.equalTo(cityLabel.snp.bottom).offset(10)
            view.left.right.equalToSuperview()
            view.bottom.equalTo(segmentView.snp.top)
        }
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        segmentView.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalTo(self.snp.bottom).inset(10)
            view.height.equalTo(40)
            view.width.equalTo(330)
        }
        customSegmentControl.snp.makeConstraints { (control) in
            control.top.bottom.equalToSuperview()
            control.left.equalToSuperview().offset(140.0)
            control.right.equalToSuperview().inset(140.0)
        }
    }
    
    // MARK: - Methods
    
    func addToMirror() {
        self.userDefault.setValue(self.defaultZipcode, forKey: "ForecastZip")
        print("SAVING: \(userDefault.object(forKey: "ForecastZip") as? String)")
        if customSegmentControl.selectedSegmentIndex == 0 {
            self.userDefault.setValue(true, forKey: "ForecastFahrenheit")
            print("SAVING: \(userDefault.object(forKey: "ForecastFahrenheit") as? Bool)")
        } else {
            self.userDefault.setValue(false, forKey: "ForecastFahrenheit")
            print("SAVING: \(userDefault.object(forKey: "ForecastFahrenheit") as? Bool)")
        }
    }
    
    func cancelTapped() {
        print("return to home page")
    }
    
    func getAPIResultsForFahrenheit() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(defaultZipcode!)&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=imperial") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getAPIResultsForCelsius() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(defaultZipcode!)&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=metric") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadUserDefaults() {

        if userDefault.object(forKey: "ForecastFahrenheit") == nil {
            self.userDefault.setValue(true, forKey: "ForecastFahrenheit")
        }
        
        if userDefault.object(forKey: "ForecastZip") == nil {
            self.userDefault.setValue("10014", forKey: "ForecastZip")
        }
        
        defaultZipcode = userDefault.object(forKey: "ForecastZip") as? String
        isFahrenheit = userDefault.object(forKey: "ForecastFahrenheit") as? Bool
        
        if isFahrenheit! {
            customSegmentControl.move(to: 0)
        }
        else {
            customSegmentControl.move(to: 1)
            self.unit = "metric"
        }
        
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(defaultZipcode!)&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=\(self.unit)") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 650))
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red:0.56, green:0.62, blue:0.67, alpha:1.0).cgColor, UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.0).cgColor]
        gradientLayer.locations = [0.0 , 1.0]
        self.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        cell.selectionStyle = .none
        
        let forecast = self.forecast[indexPath.row]
        self.cityLabel.text = forecast.name
        
        cell.descriptionLabel.text = forecast.description
        cell.minLabel.text = String(describing: forecast.min)
        cell.maxLabel.text = String(describing: forecast.max)
        
        let date = NSDate(timeIntervalSince1970: forecast.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let localDate = dateFormatter.string(from: date as Date)
        
        cell.dayLabel.text = String(describing: localDate)
        
        
        cell.setNeedsLayout()
        return cell
    }
    
    // MARK: - Search Bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("did begin")
        isSearchActive = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
        print("did end")
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("did cancel")
        isSearchActive = false
        self.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else { return }
        
        defaultZipcode = searchBar.text!
        database.child("location").setValue(searchBar.text)
        if customSegmentControl.selectedSegmentIndex == 0 {
            getAPIResultsForFahrenheit()
        } else {
            getAPIResultsForCelsius()
        }
        print("sending info to firebase")
        self.endEditing(true)
    }
    
    // MARK: - Lazy Instances
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Ok-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Cancel-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "SEARCH BY ZIPCODE"
        bar.tintColor = ColorPalette.whiteColor
        bar.barTintColor = UIColor(red:0.56, green:0.62, blue:0.67, alpha:1.0)
        bar.layer.borderWidth = 1
        bar.layer.borderColor = UIColor(red:0.56, green:0.62, blue:0.67, alpha:1.0).cgColor
        bar.searchBarStyle = UISearchBarStyle.default
        bar.isUserInteractionEnabled = true
        bar.clipsToBounds = true
        return bar
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 22)
        label.textColor = ColorPalette.whiteColor
        return label
    }()
    
    lazy var customSegmentControl: TwicketSegmentedControl = {
        let segmentedControl = TwicketSegmentedControl()
        let titles = ["℉", "℃"]
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.highlightTextColor = ColorPalette.accentColor
        segmentedControl.sliderBackgroundColor = ColorPalette.whiteColor
        segmentedControl.segmentsBackgroundColor = ColorPalette.grayColor
        segmentedControl.isSliderShadowHidden = false
        segmentedControl.backgroundColor = .clear
        return segmentedControl
    }()
    
    lazy var segmentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "forecastheader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}

extension ForecastView: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            database.child("fahrenheit").setValue(true)
            getAPIResultsForFahrenheit()
        } else {
            database.child("fahrenheit").setValue(false)
            getAPIResultsForCelsius()
        }
    }
}
