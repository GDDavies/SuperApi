//
//  DataService.swift
//  SuperApi
//
//  Created by George Davies on 07/11/2017.
//  Copyright © 2017 George. All rights reserved.
//

import Foundation

class DataService: NSObject {
    
    static let shared = DataService()
    var productURL: String?
    var gtin: String?
    var productDescription: String?
    
    private(set) var apiKey = "beaf5922dc4244f7808820e28f66e3e0"
    
    var json = [String:Any]()
    
    func searchAPI(gtin: String) {
        
        let url = URL(string: "https://dev.tescolabs.com/product/?gtin=\(gtin)")!
        let request = NSMutableURLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data {
                    // If successful pass data object to json variable as dictionary
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String:Any]
                        
                        let products = json["products"] as? [[String:Any]]
                        
                        let product = products?.first
                        if let productDesc = product, let description = productDesc["description"] as? String {
                            self.productDescription = description
                        }
                        DataService.shared.gtin = gtin
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AlbumNotification"), object: nil)
                    } catch {
                        // Error popup
                        print("Error fetching data")
                    }
                } else {
                    // Error popup
                    print("Unable to retrieve data")
                }
            })
        }
        task.resume()
        
//        // The URL we will use to get out album data from Discogs
//        print(url)
//        productURL = url
    }
    
}
