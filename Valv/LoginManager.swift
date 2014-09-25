//
//  LoginManager.swift
//  Valv
//
//  Created by Hannes Gruber on 13/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

var loginManager = LoginManager()

class LoginManager: NSObject, NSXMLParserDelegate {
    
    let session = NSURLSession.sharedSession()
    
    func logout(authKey : String, callback : (success:Bool)->Void) {
        let urlString = "http://valv.se/api/\(API_COOKIE)/auth/logout/\(authKey)"
        let escaped = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let request = NSURLRequest(URL: NSURL.URLWithString(escaped!))
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if error != nil{
                println(error.localizedDescription)
            }
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            // Cannot store a dictionary, possible beta bug!
            userDefaults.removeObjectForKey("username")
            userDefaults.removeObjectForKey("password")
            userDefaults.removeObjectForKey("authKey")
            callback(success: true)
            
        });
        task.resume()
        
    }

    
    func login(username : String, password: String, callback : (success:Bool)->Void) {
        authKey = ""
        let urlString = "http://valv.se/api/\(API_COOKIE)/auth/login/\(username)/\(password)"
        let escaped = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

        
        let request = NSURLRequest(URL: NSURL.URLWithString(escaped!))
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if error != nil {
                println(error.localizedDescription)
            }
            
            var parser : NSXMLParser = NSXMLParser.init(data: data)
            parser.delegate = self
            parser.parse()
            
            println("authKey=\(self.authKey)")
            
            if !self.authKey.isEmpty {
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                // Cannot store a dictionary, possible beta bug!
                userDefaults.setObject(username, forKey: "username")
                userDefaults.setObject(password, forKey: "password")
                userDefaults.setObject(self.authKey, forKey: "authKey")
                userDefaults.synchronize()
                
                AUTHKEY = self.authKey
                USERNAME = username
                PASSWORD = password
                
                callback(success: true)
                
            } else {
                callback(success: false)
            }
            
            
        });
        task.resume()
    }

    var authKey = ""
    var currentString = ""
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        currentString += string
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if elementName == "authentication" {
            authKey = currentString
        }
        currentString = ""
    }

   
}
