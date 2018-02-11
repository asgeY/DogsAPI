//
//  FavoriteBreedManager.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/24/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import RxSwift

class FavoriteBreedManager {
    
    static let shared = FavoriteBreedManager()
    static private let userDefaultsFavoriteArrayString = "userDefaultsFavoriteArrayString"
    var favoriteData = Variable<[String]>([])
    
    private init() {
        favoriteData.value = getFavorites()
    }
    
    private func getFavorites() -> [String] {
        if let favoritesArray = UserDefaults.standard.array(forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString) as? [String] {
            return favoritesArray
        }
        else {
            return []
        }
    }
    
    func addToFavorites(breedName:String) {
        
        // Get array or create a new one
        var newArray = [String]()
        if let favoritesArray = UserDefaults.standard.array(forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString) as? [String] {
            newArray = favoritesArray
        }
        
        // If the value doesn't exist in the array add it
        if !newArray.contains(where: { string in
            string == breedName
        }) {
            newArray.append(breedName)
            UserDefaults.standard.set(newArray, forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString)
            favoriteData.value = newArray
        }
    }
    
    func removeFromFavorites(breedName:String) {
        if let favoritesArray = UserDefaults.standard.array(forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString) as? [String] {
            
            var newArray = favoritesArray
            if let index = newArray.index(of: breedName) {
                newArray.remove(at: index)
            }
            UserDefaults.standard.set(newArray, forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString)
            favoriteData.value = newArray
        }
    }
}
