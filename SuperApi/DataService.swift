//
//  DataService.swift
//  SuperApi
//
//  Created by George Davies on 07/11/2017.
//  Copyright © 2017 George. All rights reserved.
//

import Foundation

class DataService {
    
    static let shared = DataService()
    static var productURL: String?
    
    private(set) var apiKey = "beaf5922dc4244f7808820e28f66e3e0"
    
    static func searchAPI(gtin: String) {
        
        // The URL we will use to get out album data from Discogs
        let productURL = "https://dev.tescolabs.com/product/?gtin=\(gtin)"
        
        self.productURL = productURL
    }
    
}
