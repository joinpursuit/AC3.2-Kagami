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

class ForecastView: UIView, UITableViewDelegate, UITableViewDataSource {
    
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
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        getAPIResults()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(tableView)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { (view) in
            view.top.left.right.equalToSuperview()
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
    
    func getAPIResults() {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/forecast?zip=11101&appid=93163a043d0bde0df1a79f0fdebc744f&units=imperial") { (data: Data?) in
            guard let validData = data else { return }
            if let forecastObject = Forecast.parseForecast(from: validData) {
                DispatchQueue.main.async {
                    self.forecast = forecastObject
                    self.tableView.reloadData()
                }
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
        cell.descriptionLabel.text = forecast.description
        cell.degreeLabel.text = String(describing: forecast.temperature)
        cell.setNeedsLayout()
        return cell
    }
    
    // MARK: - Lazy Instances
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = ColorPalette.whiteColor
        view.estimatedRowHeight = 175
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
