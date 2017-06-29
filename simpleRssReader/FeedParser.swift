//
//  FeedParser.swift
//  simpleRssReader
//
//  Created by neal on 2017/6/29.
//  Copyright © 2017年 Cloudoc. All rights reserved.
//

import UIKit

class FeedParser: NSObject,XMLParserDelegate {

   
    fileprivate var rssItems = [(title:String , description: String , pubDate: String)]()
    fileprivate var currentElement = ""
    
    fileprivate var currentTitle = "" {
        didSet {
            //除去字符串前后多余的空白
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    fileprivate var currentDescription = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    fileprivate var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    fileprivate var parserCompletionHander:(([(title: String , description: String, pubDate: String)]) -> Void)?
    
    
    func parseFeed(feedURL: String, competionHander:(([(title: String, description: String , pubDate: String )])-> Void )?) -> Void {
        
        parserCompletionHander = competionHander
        
        guard let feedURL = URL(string: feedURL) else {
            print("feed URL is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: feedURL) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data fetched")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }.resume()
        
    }
    
    // MARK : - XMLParser Delegate
    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentDescription = ""
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
            case "description":
            currentDescription += string
            case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = (title: currentTitle, description: currentDescription,pubDate: currentPubDate)
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHander?(rssItems)
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
