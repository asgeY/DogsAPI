//
//  FavoriteBreedCollectionViewCell.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/24/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit

class FavoriteBreedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var breedName:String?
    weak var delegate:FavoriteBreedCollectionViewCellDelegate?
    
    static private let colorPalette = [UIColor(red: 0.3971, green: 0.95, blue: 0.4088, alpha: 1.0),
                                       UIColor(red: 0.3471, green: 0.9, blue: 0.751, alpha: 1.0),
                                       UIColor(red: 0.4471, green: 0.651, blue: 1, alpha: 1.0),
                                       UIColor(red: 0.6235, green: 0.4471, blue: 1, alpha: 1.0),
                                       UIColor(red: 0.9412, green: 0.4471, blue: 1, alpha: 1.0),UIColor(red: 1, green: 0.4471, blue: 0.4471, alpha: 1.0),
                                       UIColor(red: 1, green: 0.8431, blue: 0.4471, alpha: 1.0),
                                       UIColor(red: 0.9382, green: 0.95, blue: 0.3971, alpha: 1.0)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.masksToBounds = false
        setupBaseViews()
        setupFonts()
        setupTapGestureRecognizer()
    }

    func setupBaseViews() {
        baseView.layer.cornerRadius = 15
        baseView.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 15
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowView.layer.shadowOpacity = 0.5
    }
    
    func setupFonts() {
        if let newFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 20) {
            breedNameLabel.font = newFont
            removeButton.titleLabel?.font = newFont
        }
        breedNameLabel.textColor = UIColor.white
        removeButton.setTitleColor(UIColor.white, for: .normal)
        removeButton.setTitle("X", for: .normal)
    }
    func setupTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellPressed))
        baseView.addGestureRecognizer(tapRecognizer)
    }
    func updateCell(withBreed:String, index:Int) {
        breedName = withBreed
        breedNameLabel.text = withBreed
        setBackgroundColor(forIndex: index)
    }
    
    func setBackgroundColor(forIndex:Int) {
        var moddedIndex = forIndex
        if moddedIndex > FavoriteBreedCollectionViewCell.colorPalette.count - 1 {
            moddedIndex = moddedIndex % FavoriteBreedCollectionViewCell.colorPalette.count
        }
        baseView.backgroundColor = FavoriteBreedCollectionViewCell.colorPalette[moddedIndex]
    }
    
    @objc func cellPressed() {
        if let breedName = breedName {
            delegate?.cellPressed(withBreed: breedName)
        }
    }
    
    @IBAction func removePressed(_ sender: Any) {
        if let breedName = breedName {
            FavoriteBreedManager.shared.removeFromFavorites(breedName: breedName)
        }
    }
}

protocol FavoriteBreedCollectionViewCellDelegate: class {
    func cellPressed(withBreed:String)
}
