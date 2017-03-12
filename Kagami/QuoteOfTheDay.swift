//
//  QuoteOfTheDay.swift
//  Kagami
//
//  Created by Annie Tung on 3/11/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class QuoteOfTheDay {
    var quote: String
    var author: String
    var tags: [String]
    var category: String
    var backgroundImage: String
    
    init(quote: String, author: String, tags: [String], category: String, backgroundImage: String) {
        self.quote = quote
        self.author = author
        self.tags = tags
        self.category = category
        self.backgroundImage = backgroundImage
    }
    
    convenience init?(from dict: [String:Any]) {
        
        let contents = dict["contents"] as? [String:Any]
        let quotes = contents["quotes"] as? [[String:Any]]
        
        let quote = quotes[0]["quote"] as? String
        let author = quote[0]["author"] as? String
        let tags = quotes[0]["tags"] as? [String]
        let category = quotes[0]["category"] as? String
        let backgroundImg = quote["background"] as? String
        
        self.init(quote: String, author: String, tags: [String], category: String, backgroundImage: String)
    }
    
    static func parseQuote(from data: Data?) -> QuoteOfTheDay? {
        
        let data = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let validJson = data as? [String:Any] else { return nil }
        
        return QuoteOfTheDay(from: validJson)
    }
}
