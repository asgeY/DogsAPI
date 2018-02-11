//
//  BaseViewControllerCellDelegates.swift
//  RxSwiftDogApp
//
//  Created by Leo Tsuchiya on 2/10/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit

extension BaseViewController: DogCardDelegate {
    func viewAllPressed(withBreed: String) {
        presentImageCollectionViewControllerModally(breedName: withBreed)
    }
    
    func favoritePressed(withBreed: String) {
        FavoriteBreedManager.shared.addToFavorites(breedName: withBreed)
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
}

extension BaseViewController: FavoriteBreedCollectionViewCellDelegate {
    func cellPressed(withBreed: String) {
        presentImageCollectionViewControllerModally(breedName: withBreed)
    }
    
    func deletePressed(withBreed: String) {
        FavoriteBreedManager.shared.removeFromFavorites(breedName: withBreed)
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
}
