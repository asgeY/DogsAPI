//
//  BaseViewControllerCollectionViewDatasource.swift
//  RxSwiftDogApp
//
//  Created by Leo Tsuchiya on 2/10/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit

extension BaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dogCardCollectionView {
            return modifiedCardData.count
        }
        if collectionView == favoriteCollectionView {
            return FavoriteBreedManager.shared.favoriteData.value.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dogCardCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCardCell", for: indexPath) as? DogCard {
                cell.data = modifiedCardData[indexPath.item]
                cell.updateCell()
                cell.delegate = self
                return cell
            }
        }
        if collectionView == favoriteCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteBreedCell", for: indexPath) as? FavoriteBreedCollectionViewCell {
                cell.updateCell(withBreed: FavoriteBreedManager.shared.favoriteData.value[indexPath.item], index: indexPath.item)
                cell.delegate = self
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
