//
//  ForecastTableViewCell.swift
//  Kagami
//
//  Created by Annie Tung on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class ForecastTableViewCell: UITableViewCell {
    
    static let identifier: String = "forecast"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupView() {
        self.addSubview(degreeLabel)
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.snp.top).inset(8)
            label.left.equalTo(self.snp.left).inset(8)
            label.right.equalToSuperview()
        }
        degreeLabel.snp.makeConstraints { (label) in
            label.top.equalTo(descriptionLabel.snp.bottom)
            label.left.right.equalToSuperview()
        }
    }
    
    lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 20)
        label.textColor = ColorPalette.accentColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Code-Pro-Demo", size: 24)
        label.textColor = ColorPalette.blackColor
        return label
    }()
    
    
}
