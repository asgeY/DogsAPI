//
//  FavoriteBreedManager.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/24/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation

class FavoriteBreedManager {
    
    static let shared = FavoriteBreedManager()
    static private let userDefaultsFavoriteArrayString = "userDefaultsFavoriteArrayString"
    
    private init() {
        
    }
    
    func getFavorites() -> [String] {
        if let favoritesArray = UserDefaults.standard.array(forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString) as? [String] {
            return favoritesArray
        }
        else {
            return []
        }
    }
    
    func addToFavorites(breedName:String) {
        // Check if favorites array exists
        if let favoritesArray = UserDefaults.standard.array(forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString) as? [String] {
            var newArray = favoritesArray
            if !newArray.contains(where: { string in
                string == breedName
            }) {
                newArray.append(breedName)
                UserDefaults.standard.set(newArray, forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString)
            }
        }
        // Otherwise create it with the new favorited item
        else {
            UserDefaults.standard.set([breedName], forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString)
        }
    }
    
    func removeFromFavorites(breedName:String) {
        if let favoritesArray = UserDefaults.standard.array(forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString) as? [String] {
            
            var newArray = favoritesArray
            if let index = newArray.index(of: breedName) {
                newArray.remove(at: index)
            }
            UserDefaults.standard.set(newArray, forKey: FavoriteBreedManager.userDefaultsFavoriteArrayString)
        }
    }
}
