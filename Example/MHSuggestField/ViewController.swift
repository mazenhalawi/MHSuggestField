//
//  ViewController.swift
//  MHSuggestField
//
//  Created by Mazen on 08/01/2019.
//  Copyright (c) 2019 Mazen. All rights reserved.
//

import UIKit
import MHSuggestField

class ViewController: UIViewController {
    
    @IBOutlet weak var txtSuggest:SuggestField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMe)))
        
        txtSuggest.allowEmptyField = true
        txtSuggest.canFilterList = true
        txtSuggest.restrictValues = true
        txtSuggest.datasource = ["Apple", "Orange", "Banana", "Tomato"]
        txtSuggest.suggestDelegate = self
    }
    
    @objc private func dismissMe() {
        self.view.endEditing(true)
    }
    
}

extension ViewController : SuggestFieldDelegate {
    
    func alertNotInList(value: String) {
        print("input value not in list")
    }
    
    func suggestFieldDidBeginEditing(_ suggestField: SuggestField) {
        print("did begin editing")
    }
    
    func suggestFieldDidEndEditing(_ suggestField: SuggestField) {
        print("did end editing")
    }
    
    
    
}

