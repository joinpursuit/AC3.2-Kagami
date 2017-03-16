//
//  QuoteCollectionViewCell.swift
//  Kagami
//
//  Created by Annie Tung on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class QuoteCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints({ (label) in
            label.centerX.equalTo(self.snp.centerX)
            label.centerY.equalTo(self.snp.centerY)
        })
    }
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = ColorPalette.whiteColor
        return label
    }()

}
