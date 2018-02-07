//
//  DogData.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/22/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit

struct DogAPIJSON: Decodable {
    let status:String
    let message:DogAPIMessage
}

struct DogAPIMessage: Decodable {
    let objectArray:[String]?
    let singleObject:URL?
    
    init(from decoder:Decoder) throws {
        let container = try decoder.singleValueContainer()
        // Since the API can return message types of string arrays, urls and url arrays, determine the message type by trying to decode the message
        do {
            if let unwrappedURL = try? container.decode(URL.self) {
                singleObject = unwrappedURL
                objectArray = nil
                return
            }
            if let unwrappedBreeds = try? container.decode([String].self) {
                objectArray = unwrappedBreeds
                singleObject = nil
                return
            }
        }
        objectArray = nil
        singleObject = nil
    }
}
