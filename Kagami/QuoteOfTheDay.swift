//
//  QuoteOfTheDay.swift
//  Kagami
//
//  Created by Annie Tung on 3/11/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit

class QuoteOfTheDay {
    
    var quote: String
    var author: String
    var category: String
    var backgroundImageURL: String
    
    init(quote: String, author: String, category: String, backgroundImageURL: String) {
        self.quote = quote
        self.author = author
        self.category = category
        self.backgroundImageURL = backgroundImageURL
    }
    
    convenience init?(from dict: [String:Any]) {
        
        let contents = dict["contents"] as? [String:Any]
        let quotes = contents?["quotes"] as? [[String:Any]]
        
        let quote = quotes?[0]["quote"] as? String ?? "no quote"
        let author = quotes?[0]["author"] as? String ?? "no author"
        let category = quotes?[0]["category"] as? String ?? "no category"
        let backgroundImageURL = quotes?[0]["background"] as? String ?? "no image"
        
        self.init(quote: quote, author: author, category: category, backgroundImageURL: backgroundImageURL)
    }
    
    static func parseQuote(from data: Data?) -> QuoteOfTheDay? {
        let data = try? JSONSerialization.jsonObject(with: data!, options: [])
        guard let validJson = data as? [String:Any] else { return nil }
        
        return QuoteOfTheDay(from: validJson)
    }
}
