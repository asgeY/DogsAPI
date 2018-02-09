//
//  DogCardData.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/22/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation

class DogCardData {
    let breedName:String
    var randomImageURL:URL?
    var allImageURLs:[URL]?
    
    init(breedName:String) {
        self.breedName = breedName
        randomImageURL = nil
        allImageURLs = nil
    }
}
