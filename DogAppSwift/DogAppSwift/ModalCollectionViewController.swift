//
//  ModalCollectionViewController.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/24/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit
import Kingfisher

class ModalCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    var imageURLs:[URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        setupFlowLayout()
        setupCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupCloseButton() {
        closeButton.backgroundColor = UIColor.white
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        closeButton.layer.cornerRadius = 15
        closeButton.setTitle("X", for: .normal)
    }
    
    func setupFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 75, left: 0, bottom: 75, right: 0)
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
    }
    
    func setCollectionViewItemSizes() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.bounds.width * 0.75, height: collectionView.bounds.width * 0.75)
            layout.sectionInset = UIEdgeInsets(top: (collectionView.bounds.height - layout.itemSize.height) / 2,
                                               left: (collectionView.bounds.width - layout.itemSize.width) / 2,
                                               bottom: (collectionView.bounds.height - layout.itemSize.height) / 2,
                                               right: (collectionView.bounds.width - layout.itemSize.width) / 2)
        }
    }
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension ModalCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cell = collectionView.cellForItem(at: indexPath) {
            return cell.bounds.size
        }
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.width/2)
    }
}

extension ModalCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        cell.layer.cornerRadius = 10
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = nil
            if let url = imageURLs?[indexPath.item] {
                DispatchQueue.main.async {
                    imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (_, _, _, _) in
                            if let image = imageView.image {
                            let size = self.getScaledSize(image: image, collectionView: collectionView)
                            cell.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                            collectionView.collectionViewLayout.invalidateLayout()
                        }
                        
                        
                        })
                }
            }
        }
        return cell
    }
    
    func getScaledSize(image:UIImage, collectionView:UICollectionView) -> CGSize {
        if image.size.width > collectionView.bounds.width * 0.8 {
            return CGSize(width: collectionView.bounds.width * 0.8, height: image.size.height * (collectionView.bounds.width * 0.8 / image.size.width))
        }
        return image.size
    }
}
