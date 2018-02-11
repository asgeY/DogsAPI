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
}

extension BaseViewController: FavoriteBreedCollectionViewCellDelegate {
    func cellPressed(withBreed: String) {
        presentImageCollectionViewControllerModally(breedName: withBreed)
    }
}
