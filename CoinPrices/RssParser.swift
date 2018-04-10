//
//  XmlParser.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/10/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RssParserDelegate{
    func parsingWasFinished()
}

class RssParser: NSObject, XMLParserDelegate {

    var arrParsedData = [Dictionary<String, String>]()
    
    var currentDataDictionary = Dictionary<String, String>()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var delegate : RssParserDelegate?
    
    
    func startParsingWithContentsOfURL(rssURL: NSURL) {
        let parser = XMLParser(contentsOf: rssURL as URL)
        parser?.delegate = self
        parser?.parse()
    }
    
    
    
    //MARK: XMLParserDelegate method implementation
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate!.parsingWasFinished()
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            
            if elementName == "link"{
                foundCharacters = (foundCharacters as NSString).substring(from: 3)
            }
            
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if currentElement == "pubDate" {
                arrParsedData.append(currentDataDictionary)
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "title" || currentElement == "link" || currentElement == "pubDate") {
            foundCharacters += string
        }
    }
    
    
    func parser(parseErrorOccurred parseError: Error!) {
        print(parseError.localizedDescription)
    }
    
    
    func parser(validationErrorOccurred validationError: Error!) {
        print(validationError.localizedDescription)
    }
    
}
