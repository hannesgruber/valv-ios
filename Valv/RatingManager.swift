//
//  RatingManager.swift
//  Valv
//
//  Created by Hannes Gruber on 15/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

var ratingManager = RatingManager()

class RatingManager: NSObject, NSXMLParserDelegate {
    
    let session = NSURLSession.sharedSession()
    
    func rate(productId: String, rating: Int, callback : (success: Bool)->Void) {
        
        var urlString:String! = "http://valv.se/api/\(API_COOKIE)/products/rate/\(productId)/\(rating)/\(AUTHKEY)"
        
        let escaped:String! = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

        
        println(escaped)
        
        let request = NSURLRequest(URL: NSURL.URLWithString(escaped))
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            
            // TODO: Handle errors. invalid authkey results in http 200 but error tag in xml
            
            if (error != nil) {
                println(error.localizedDescription)
            }
            
            var parser : NSXMLParser = NSXMLParser.init(data: data)
            parser.delegate = self
            parser.parse()
            
            callback(success: self.success)
        });
        task.resume()
    }
    
    
    var success = false
    var currentString = ""
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [String : String]!) {
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        currentString += string
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        println("elementName=\(elementName) currentString=\(currentString)")
        
        if elementName == "result" {
            success = (currentString == "success")
        }
        currentString = ""
    }

   
}
