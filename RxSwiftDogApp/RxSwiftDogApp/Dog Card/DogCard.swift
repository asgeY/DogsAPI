//
//  DogCard.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/22/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit
import Kingfisher

class DogCard: UICollectionViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var gradientMaskView: ViewWithGradient!
    
    var data:DogCardData?
    weak var delegate:DogCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.masksToBounds = false
        imageView.contentMode = .scaleAspectFill
        setupBaseViews()
        setupGradientMaskView()
        setupFonts()
    }
    
    func setupBaseViews() {
        baseView.layer.cornerRadius = 10
        baseView.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowView.layer.shadowOpacity = 0.5
    }
    
    func setupGradientMaskView() {
        gradientMaskView.backgroundColor = UIColor.clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        gradientMaskView.layer.addSublayer(gradientLayer)
        gradientMaskView.isHidden = true
    }
    
    func setupFonts() {
        if let newFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 40) {
            nameLabel.font = newFont
        }
        if let newFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 20) {
            favoriteButton.titleLabel?.font = newFont
            viewAllButton.titleLabel?.font = newFont
        }
        nameLabel.textColor = UIColor.white
        favoriteButton.setTitleColor(UIColor.white, for: .normal)
        viewAllButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func updateCell() {
        guard let data = data else {
            return
        }
        nameLabel.text = data.breedName
        // Check if the image url is already downloaded
        if let imageURL = data.randomImageURL {
            imageView.kf.setImage(with: imageURL)
        }
        // Otherwise download it, set the data then update the image
        else {
            self.gradientMaskView.isHidden = true
            DogAPIManager.shared.getRandomDogImageURL(ofBreed: data.breedName) { url in
                guard let url = url else {
                    return
                }
                self.data?.randomImageURL = url
                DispatchQueue.main.async {
                    self.imageView.kf.setImage(with: url) { _,_,_,_ in
                        self.gradientMaskView.isHidden = false
                    }
                }
            }
        }
    }
    // Clean up any images before cell reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        gradientMaskView.isHidden = true
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        if let breedName = data?.breedName {
            delegate?.viewAllPressed(withBreed: breedName)
        }
    }
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let breedName = data?.breedName {
            delegate?.favoritePressed(withBreed: breedName)
        }
    }
}

protocol DogCardDelegate: class {
    func viewAllPressed(withBreed:String)
    func favoritePressed(withBreed:String)
}
