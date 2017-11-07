//
//  InformationViewController.swift
//  SuperApi
//
//  Created by George Davies on 07/11/2017.
//  Copyright © 2017 George. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var informationLbl: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        informationLbl.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(setLabels), name: NSNotification.Name(rawValue: "AlbumNotification"), object: nil)
    }
    
    @objc func setLabels(){
        
        informationLbl.text = "\(DataService.shared.productURL)"
    }

}
