//
//  QuoteOfTheDay.swift
//  Kagami
//
//  Created by Annie Tung on 3/11/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class QuoteOfTheDay: Widgetable {
    
    var quote: String
    var author: String
    var type: String
    var backgroundImageURL: String
    var category: String = "quote"
    var iconImage: UIImage = #imageLiteral(resourceName: "quote")
    var description: String = "quote"
    
    init(quote: String, author: String, type: String, backgroundImageURL: String) {
        self.quote = quote
        self.author = author
        self.type = type
        self.backgroundImageURL = backgroundImageURL
    }
    
    convenience init?(from dict: [String:Any]) {
        
        let contents = dict["contents"] as? [String:Any]
        let quotes = contents?["quotes"] as? [[String:Any]]
        
        let quote = quotes?[0]["quote"] as? String ?? "no quote"
        let author = quotes?[0]["author"] as? String ?? "no author"
        let type = quotes?[0]["category"] as? String ?? "no category"
        let backgroundImageURL = quotes?[0]["background"] as? String ?? "no image"
        
        self.init(quote: quote, author: author, type: type, backgroundImageURL: backgroundImageURL)
    }
    
    static func parseQuote(from data: Data?) -> QuoteOfTheDay? {
        let data = try? JSONSerialization.jsonObject(with: data!, options: [])
        guard let validJson = data as? [String:Any] else { return nil }
        
        return QuoteOfTheDay(from: validJson)
    }
}
