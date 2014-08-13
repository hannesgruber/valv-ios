//
//  SearchManager.swift
//  Valv
//
//  Created by Hannes Gruber on 11/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

var searchManager = SearchManager()

struct searchResult {
    var name = "unnamed"
    var description = "undescribed"
}


class SearchManager: NSObject, NSXMLParserDelegate {
    
    let session = NSURLSession.sharedSession()
    let kaka = "563d427e56666f2866403c357e"
    var searchResults = [product]()

    func clearSearchResults(){
        searchResults.removeAll(keepCapacity: false)
    }
    
    func search(searchString : String, callback : ()->Void) {

        var urlString = "http://valv.se/api/\(kaka)/products/search?q=\(searchString)&page=1&pageSize=100"
        
        if(!AUTHKEY.isEmpty) {
            urlString += "&authKey=\(AUTHKEY)"
        }
        
        let escaped = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        println(escaped)

        let request = NSURLRequest(URL: NSURL.URLWithString(escaped))
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if error {
                println(error.localizedDescription)
            }
            
            var parser : NSXMLParser = NSXMLParser.init(data: data)
            parser.delegate = self
            parser.parse()
            
            for p:product in self.products{
                println(p.toString())
            }
            
            self.searchResults = self.products
            
            callback()
        });
        task.resume()
    }
    
    
    var products: [product]!
    struct product {
        var uuid = ""
        var title = ""
        var category = ""
        var imageUuid = ""
        var imageLicense = ""
        var imageFallback = ""
        var description = ""
        var ratingValue = ""
        var ratingCount = ""
        var userRating = ""
        var userProposedRating = ""
        
        func toString()->String {
            return "Product uuid:\(uuid) title:\(title) category:\(category) userRating:\(userRating)"
        }
    }
    
    var currentProduct: product!
    var currentParentElement: String!
    var currentElement: String!
    var currentString = ""
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [String : String]!) {
        
        if elementName == "products" {
            products = [product]()
        }
        if elementName == "product" {
            currentProduct = product()
            currentParentElement = elementName
        }
        if(elementName == "category") {
            currentParentElement = elementName
        }
        if(elementName == "product-image") {
            currentParentElement = elementName
        }
        if(elementName == "rating") {
            currentProduct.ratingValue = attributeDict["value"]!
            currentProduct.ratingCount = attributeDict["count"]!
            currentParentElement = elementName
        }
        
        currentElement = elementName
    }

    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        currentString += string
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if elementName == "title" && currentParentElement == "product" {
            currentProduct.title = currentString
        }
        if elementName == "uuid" && currentParentElement == "product" {
            currentProduct.uuid = currentString
        }
        if elementName == "title" && currentParentElement == "category" {
            currentProduct.category = currentString
        }
        if elementName == "uuid" && currentParentElement == "product-image"{
            currentProduct.imageUuid = currentString
        }
        if elementName == "license" {
            currentProduct.imageLicense = currentString
        }
        if elementName == "fallback" {
            currentProduct.imageFallback = currentString
        }
        if elementName == "description" {
            currentProduct.description = currentString
        }
        if elementName == "rated" {
            currentProduct.userRating = currentString
        }
        if elementName == "proposed" {
            currentProduct.userProposedRating = currentString
        }
        if elementName == "product" {
            products.append(currentProduct)
        }
        
        
        currentString = ""
    }
}
