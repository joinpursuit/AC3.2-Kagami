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
import FirebaseDatabase

class QuoteView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: - Properties
    var quote: QuoteOfTheDay?
    var database: FIRDatabaseReference!
    let categories = ["inspire","management","sports","life","funny","love","art","students"]
    var gradientLayer: CAGradientLayer!
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGradientLayer()
        self.layer.cornerRadius = 9
        setupHierarchy()
        setupConstraints()
        getAPIResults()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.database = FIRDatabase.database().reference().child("quote")
        collectionView.register(QuoteCollectionViewCell.self, forCellWithReuseIdentifier: "categories")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    func setupHierarchy() {
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(quoteLabel)
        self.addSubview(authorLabel)
        self.addSubview(collectionView)
        self.addSubview(headerImage)
        
        doneButton.addTarget(self, action: #selector(saveQuote), for: .touchUpInside)
    }
    
    func setupConstraints() {
        headerImage.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(self.snp.top).inset(40)
        }
        
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        quoteLabel.snp.makeConstraints { (label) in
            label.top.equalTo(collectionView.snp.bottom).offset(15)
            label.left.equalTo(self).inset(8)
            label.right.equalTo(self).inset(8)
        }
        
        authorLabel.snp.makeConstraints { (label) in
            label.top.equalTo(quoteLabel.snp.bottom).offset(5)
            label.right.equalTo(self.snp.right).inset(20)
        }
       
        collectionView.snp.makeConstraints { (view) in
            view.top.equalTo(headerImage.snp.bottom).offset(30)
            view.left.equalTo(self.snp.left).inset(8)
            view.right.equalToSuperview()
            view.height.equalTo(40)
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
    
    // MARK: - Settings Methods
    func saveQuote() {
        database.child("fullQuote").setValue(quote!.quote)
        database.child("author").setValue(quote!.author)
    }
    
    func getAPIResults() {
        APIRequestManager.manager.getData(endPoint: "http://quotes.rest/qod.json") { (data: Data?) in
            guard let validData = data else { return }
            if let quoteObject = QuoteOfTheDay.parseQuote(from: validData) {
                self.quote = quoteObject
                self.quoteLabel.text = self.quote?.quote
                self.authorLabel.text = self.quote?.author
            }
        }
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categories", for: indexPath) as! QuoteCollectionViewCell
        cell.backgroundColor = ColorPalette.grayColor
        cell.layer.borderColor = ColorPalette.grayColor.cgColor
        cell.layer.borderWidth = 1.0
        cell.categoryLabel.text = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = categories[indexPath.item]
        database.child("category").setValue(selected)
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
    
    // MARK: - Lazy Instantiates
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
    
    lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Code-Pro-Demo", size: 20)
        label.textColor = ColorPalette.whiteColor
        label.text = "Motivational quote here"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Code-Pro-Demo", size: 14)
        label.textColor = ColorPalette.whiteColor
        label.text = "By..."
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 35)
        let frame: CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        let view: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "quoteheader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
