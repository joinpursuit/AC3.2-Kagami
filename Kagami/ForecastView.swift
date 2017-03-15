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

class ForecastView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var isSearchActive: Bool = false
    var database: FIRDatabaseReference!
    let userDefault = UserDefaults.standard
    var forecast: [Forecast] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.database = FIRDatabase.database().reference().child("forecast")
        self.backgroundColor = ColorPalette.whiteColor
        self.alpha = 0.8
        self.layer.cornerRadius = 9
        setupHierarchy()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        getAPIResults()
        searchBar.delegate = self
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(tableView)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(searchBar)
        self.addSubview(cityLabel)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { (view) in
            view.top.left.right.equalToSuperview()
            view.height.equalTo(50)
        }
        cityLabel.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(searchBar.snp.bottom)
        }
        tableView.snp.makeConstraints { (view) in
            view.top.equalTo(cityLabel.snp.bottom)
            view.left.right.equalToSuperview()
            view.bottom.equalTo(self.snp.bottom).inset(25)
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
    
    func addToMirror() {
        print("adding to mirror")
    }
    
    func cancelTapped() {
        print("return to home page")
    }
    
    func getAPIResults() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=11101&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=imperial") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getAPIResultsForFahrenheit() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(searchBar.text!)&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=imperial") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                dump(self.forecast)
            }
        }
    }
    
    func getAPIResultsForCelsius() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(searchBar.text!)&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=metric") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                dump(self.forecast)
            }
        }
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
        isSearchActive = true
        print("did begin")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
        print("did end")
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("did cancel")
        isSearchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searching")
        guard searchBar.text != nil else { return }
        database.child("location").setValue(searchBar.text)
        getAPIResultsForFahrenheit()
        self.endEditing(true)
    }
    
    // MARK: - Lazy Instances
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = ColorPalette.whiteColor
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
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "ENTER ZIPCODE"
        bar.tintColor = ColorPalette.whiteColor
        bar.barTintColor = ColorPalette.whiteColor
        bar.searchBarStyle = UISearchBarStyle.default
        //        bar.clipsToBounds = true
        return bar
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 22)
        label.textColor = ColorPalette.blackColor
        return label
    }()
}
