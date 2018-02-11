//
//  BaseViewControllerUITextFieldDelegate.swift
//  RxSwiftDogApp
//
//  Created by Leo Tsuchiya on 2/10/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit

extension BaseViewController: UITextFieldDelegate {
    // Hide keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // Hide keyboard on touch of main view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Process text modified events
    func searchTextModified(to text:String) {
        if text == "" {
            modifiedCardData = baseCardData.value
        } else {
            let filteredData = baseCardData.value.filter{ data in
                return data.breedName.range(of: text, options: .caseInsensitive) != nil
            }
            modifiedCardData = filteredData
        }
        DispatchQueue.main.async {
            self.dogCardCollectionView.reloadData()
        }
    }
}
