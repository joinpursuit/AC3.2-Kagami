//
//  SelectionCollectionViewCell.swift
//  Kagami
//
//  Created by Annie Tung on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class SelectionCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "Selection"
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconImage)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        iconImage.snp.makeConstraints { (image) in
            image.top.bottom.left.right.equalToSuperview()
        }
    }
    
    lazy var iconImage: UIImageView = {
        let image = UIImage(named: "Appointment Reminders-50")
        let im = UIImageView(image: image)
        im.contentMode = .scaleToFill
        return im
    }()
    
}
