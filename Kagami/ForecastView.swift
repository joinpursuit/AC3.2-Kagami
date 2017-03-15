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

class ForecastView: UIView, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var isSearchActive: Bool = false
    var database: FIRDatabaseReference!
    let userDefault = UserDefaults.standard
    var forecast: Forecast?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.database = FIRDatabase.database().reference().child("forecast")
        self.backgroundColor = ColorPalette.whiteColor
        self.alpha = 0.8
        self.layer.cornerRadius = 9
        setupHierarchy()
        configureConstraints()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(tableView)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(10)
            view.width.equalToSuperview().multipliedBy(0.60)
            view.height.equalTo(40)
        }
        tableView.snp.makeConstraints { (view) in
            view.top.equalTo(searchBar.snp.bottom)
            view.left.right.equalToSuperview()
            view.bottom.equalTo(self.snp.bottom).inset(30)
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
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        return cell
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("did begin")
        isSearchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("did end")
        isSearchActive = false
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        guard searchBar.text != nil else { return }
        
        database.child("location").setValue(searchBar.text)
        getAPIResults()
        
        print("location setting to firebase")
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        isSearchActive = false
    }
    
    func getAPIResults() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast?zip=(searchBar.text!)&appid=93163a043d0bde0df1a79f0fdebc744f&units=imperial") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                self.forecast = forecastObject
                dump(self.forecast)
                DispatchQueue.main.async {
                    //update labels
//                    self.layoutxIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Lazy Instances
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .purple
        view.estimatedRowHeight = 75
        return view
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
