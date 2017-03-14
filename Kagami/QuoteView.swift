//
//  QuoteView.swift
//  Kagami
//
//  Created by Annie Tung on 3/11/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class QuoteView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    var quote: QuoteOfTheDay?
    let categories = ["inspire","management","sports","life","funny","love","art","students"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorPalette.whiteColor
        self.alpha = 0.8
        self.layer.cornerRadius = 9
        setupHierarchy()
        setupConstraints()
        getAPIResults()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QuoteCollectionViewCell.self, forCellWithReuseIdentifier: "categories")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Hierarchy & Constraints
    
    func setupHierarchy() {
        self.addSubview(backgroundImage)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(quoteLabel)
        self.addSubview(authorLabel)
        self.addSubview(collectionView)
    }
    
    func setupConstraints() {
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        quoteLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.snp.top).inset(125)
            label.left.equalTo(self).inset(8)
            label.right.equalTo(self).inset(8)
        }
        authorLabel.snp.makeConstraints { (label) in
            label.top.equalTo(quoteLabel.snp.bottom).offset(10)
            label.right.equalTo(self.snp.right).inset(20)
        }
        backgroundImage.snp.makeConstraints { (image) in
            image.top.bottom.right.left.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (view) in
            view.top.equalTo(self.snp.top).inset(8)
            view.left.equalTo(self.snp.left).inset(8)
            view.right.equalToSuperview()
            view.height.equalTo(40)
        }
    }
    
    // MARK: - Methods
    
    func getAPIResults() {
        APIRequestManager.manager.getData(endPoint: "http://quotes.rest/qod.json") { (data: Data?) in
            guard let validData = data else { return }
            if let quoteObject = QuoteOfTheDay.parseQuote(from: validData) {
                self.quote = quoteObject
                dump(self.quote)
                self.quoteLabel.text = self.quote?.quote
                self.authorLabel.text = self.quote?.author
                if let background = self.quote?.backgroundImageURL {
                    self.backgroundImage.image = UIImage(named: background)
                }
            }
        }
    }
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categories", for: indexPath) as! QuoteCollectionViewCell
            cell.backgroundColor = ColorPalette.accentColor
            cell.layer.borderColor = ColorPalette.whiteColor.cgColor
            cell.layer.borderWidth = 1.0
            cell.categoryLabel.text = categories[indexPath.row]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = categories[indexPath.item]
            APIRequestManager.manager.getData(endPoint: "http://quotes.rest/qod.json?category=\(selected)", callback: { (data: Data?) in
                guard let validData = data else { return }
                if let quoteObject = QuoteOfTheDay.parseQuote(from: validData) {
                    DispatchQueue.main.async {
                        self.quote = quoteObject
                        self.quoteLabel.text = self.quote?.quote
                        self.authorLabel.text = self.quote?.author
                    }
                }
            })
        }
    
    // MARK: - Lazy Instances
    
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
    
    lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Code-Pro-Demo", size: 25)
        label.textColor = ColorPalette.blackColor
        label.text = "Motivational quote here"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Code-Pro-Light-Demo", size: 18)
        label.textColor = ColorPalette.blackColor
        label.text = "By..."
        return label
    }()
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 35)
        let frame: CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        let view: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.backgroundColor = ColorPalette.whiteColor
        return view
    }()
}
