//
//  ToDoTableViewCell.swift
//  Kagami
//
//  Created by Annie Tung on 3/7/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class ToDoTableViewCell: UITableViewCell {
    
    static let identifier: String = "ToDoList"

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        addSubview(label)
//        label.snp.makeConstraints { (label) in
//            label.top.left.right.bottom.equalToSuperview()
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    lazy var label: UILabel = {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
//        return label
//    }()

}
