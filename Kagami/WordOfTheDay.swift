//
//  WordOfTheDay.swift
//  Kagami
//
//  Created by Marcel Chaucer on 3/2/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

//API Endpoint
//http://api.wordnik.com/v4/words.json/wordOfTheDay?api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5

class WordOfTheDay {
    var word: String
    var definition: String
    var partOfSpeech: String
    
    init(word: String, definition: String, partOfSpeech: String) {
        
        self.word = word
        self.definition = definition
        self.partOfSpeech = partOfSpeech
    }
    
    convenience init?(from dictionary: [String:Any])  {
        //The Word
        
        let word = dictionary["word"] as? String
       
        //Get Into Dictionary Array
        let definitionArray = dictionary["definitions"] as! [[String: String]]
        let definition = definitionArray[0]["text"]
        let partOfSpeech = definitionArray[0]["partOfSpeech"]
        
        self.init(word: word!, definition: definition!, partOfSpeech: partOfSpeech!)
    }
    
    static func parseWordOfDay(from: Data?) -> WordOfTheDay? {
        
        let data = try? JSONSerialization.jsonObject(with: from!, options: [])
        guard let validJson = data as? [String: Any] else { return nil }
        
        return WordOfTheDay(from: validJson)
    }
}
