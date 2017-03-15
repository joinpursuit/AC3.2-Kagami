//
//  ForecastTableViewCell.swift
//  Kagami
//
//  Created by Annie Tung on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let identifier: String = "forecast"

    override func awakeFromNib() {
        super.awakeFromNib()

        //        self.addSubview(degreeLabel)
        //        self.addSubview(locationLabel)
        //        self.addSubview(descriptionLabel)
        //        self.addSubview(lowestTempLabel)
        //        self.addSubview(minMaxDegreeLabel)
        //        self.addSubview(highestTempLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //        degreeLabel.snp.makeConstraints { (label) in
    //            label.centerX.equalToSuperview()
    //            label.top.equalTo(searchBar.snp.bottom).offset(20)
    //        }
    //
    //        locationLabel.snp.makeConstraints { (label) in
    //            label.centerX.equalToSuperview()
    //            label.top.equalTo(degreeLabel.snp.bottom).offset(10)
    //        }
    //
    //        descriptionLabel.snp.makeConstraints { (label) in
    //            label.centerX.equalToSuperview()
    //            label.top.equalTo(locationLabel.snp.bottom).offset(10)
    //        }
    //
    //        minMaxDegreeLabel.snp.makeConstraints { (label) in
    //            label.centerX.equalToSuperview()
    //            label.top.equalTo(descriptionLabel.snp.bottom).offset(10)
    //        }
    //
    //        lowestTempLabel.snp.makeConstraints { (label) in
    //            label.right.equalTo(minMaxDegreeLabel.snp.left)
    //            label.centerY.equalTo(minMaxDegreeLabel)
    //        }
    //
    //        highestTempLabel.snp.makeConstraints { (label) in
    //            label.left.equalTo(minMaxDegreeLabel.snp.right)
    //            label.centerY.equalTo(minMaxDegreeLabel)
    //        }
    
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Entering a Zipcode above"
        label.font = UIFont(name: "Code-Pro-Demo", size: 20)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "69"
        label.font = UIFont(name: "Code-Pro-Demo", size: 70)
        label.textColor = ColorPalette.blackColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 18)
        label.textColor = ColorPalette.accentColor
        return label
    }()
    
    lazy var lowestTempLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 18)
        label.textColor = ColorPalette.grayColor
        return label
    }()
    
    lazy var minMaxDegreeLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = UIFont(name: "Code-Pro-Demo", size: 18)
        label.textColor = ColorPalette.grayColor
        return label
    }()
    
    lazy var highestTempLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 18)
        label.textColor = ColorPalette.grayColor
        return label
    }()
    
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 18)
        label.textColor = ColorPalette.grayColor
        return label
    }()
    

}
