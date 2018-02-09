//
//  DogAPIManager.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/22/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit

class DogAPIManager {
    // Singleton object to access dogAPI
    // Use by calling DogAPIManager.shared.function
    static let shared = DogAPIManager()
    
    private init() {
        
    }
    
    func getAllBreedNames(completed: @escaping ([String]?)->()) {
        guard let url = URL(string: "https://dog.ceo/api/breeds/list") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let retrievedData = data {
                do {
                    let json = try JSONDecoder().decode(DogAPIJSON.self, from: retrievedData)
                    if let breedList = json.message.objectArray {
                        completed(breedList)
                        return
                    }
                    completed(nil)
                } catch {
                    print("Couldn't decode JSON in getAllBreedNames.")
                }
            }
        }
        task.resume()
    }
    
    func getRandomDogImageURL(completed: @escaping (URL?) -> ()) {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let retrievedData = data {
                do {
                    let json = try JSONDecoder().decode(DogAPIJSON.self, from: retrievedData)
                    
                    if let imageURL = json.message.singleObject {
                        completed(imageURL)
                        return
                    }
                    completed(nil)
                } catch {
                    print("Couldn't decode JSON in getRandomDogImageURL.")
                }
            }
        }
        task.resume()
    }

    func getRandomDogImageURL(ofBreed:String, completed: @escaping (URL?)->()) {
        guard let url = URL(string: "https://dog.ceo/api/breed/"+ofBreed+"/images/random") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let retrievedData = data {
                do {
                    let json = try JSONDecoder().decode(DogAPIJSON.self, from: retrievedData)
                    if let imageURL = json.message.singleObject {
                        completed(imageURL)
                        return
                    }
                    completed(nil)
                } catch {
                    print("Couldn't decode JSON in getRandomDogImageURL(ofBreed).")
                }
            }
        }
        task.resume()
    }
    func getAllImageURLs(ofBreed:String, completed: @escaping ([URL]?) -> ()) {
        guard let url = URL(string: "https://dog.ceo/api/breed/"+ofBreed+"/images") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let retrievedData = data {
                do {
                    let json = try JSONDecoder().decode(DogAPIJSON.self, from: retrievedData)
                    if let imageURLStrings = json.message.objectArray {
                        var urls = [URL]()
                        for string in imageURLStrings {
                            if let url = URL(string: string) {
                                urls.append(url)
                            }
                        }
                        completed(urls)
                        return
                    }
                    completed(nil)
                } catch {
                    print("Couldn't decode JSON in getAllImageURLs.")
                }
            }
        }
        task.resume()
    }
}
