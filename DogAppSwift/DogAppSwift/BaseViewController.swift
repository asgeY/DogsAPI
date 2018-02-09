//
//  ViewController.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/22/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var baseCardData = [DogCardData]()
    var modifiedCardData = [DogCardData]()
    var interstitialLoadingView:InterstitialLoadingView?
    
    @IBOutlet weak var dogCardCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interView = InterstitialLoadingView(frame: view.bounds)
        view.addSubview(interView)
        interstitialLoadingView = interView
        
        // Download all breed names and populate the data array
        DogAPIManager.shared.getAllBreedNames() { breeds in
            if let breeds = breeds {
                for breed in breeds {
                    let newDogData = DogCardData(breedName: breed)
                    self.baseCardData.append(newDogData)
                }
                self.modifiedCardData = self.baseCardData
                DispatchQueue.main.async {
                    interView.isHidden = true
                    self.dogCardCollectionView.reloadData()
                }
            }
        }
        // Register custom collectionviewcell nib for reuse
        let dogCardNib = UINib(nibName: "DogCard", bundle: Bundle.main)
        dogCardCollectionView.register(dogCardNib, forCellWithReuseIdentifier: "DogCardCell")
        dogCardCollectionView.dataSource = self
        dogCardCollectionView.showsHorizontalScrollIndicator = false
        dogCardCollectionView.layer.masksToBounds = false
        setupCardFlowLayout()
        
        let favoriteNib = UINib(nibName: "FavoriteBreedCollectionViewCell", bundle: Bundle.main)
        favoriteCollectionView.register(favoriteNib, forCellWithReuseIdentifier: "favoriteBreedCell")
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.showsHorizontalScrollIndicator = false
        favoriteCollectionView.layer.masksToBounds = false
        setupFavoriteFlowLayout()
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCollectionViewItemSizes()
    }
    
    func setupCardFlowLayout() {
        let layout = CustomFlowLayout(scrollDirection: .horizontal)
        dogCardCollectionView.collectionViewLayout = layout
    }
    func setupFavoriteFlowLayout() {
        let layout = CustomFlowLayout(scrollDirection: .horizontal)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        favoriteCollectionView.collectionViewLayout = layout
    }
    func setCollectionViewItemSizes() {
        if let layout = favoriteCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: favoriteCollectionView.bounds.width * 0.65, height: favoriteCollectionView.bounds.height * 0.7 / 3)
            layout.sectionInset = UIEdgeInsets(top: favoriteCollectionView.bounds.height * 0.1, left: (favoriteCollectionView.bounds.width - layout.itemSize.width) / 2, bottom: favoriteCollectionView.bounds.height * 0.1, right: (favoriteCollectionView.bounds.width - layout.itemSize.width) / 2)
        }
        if let layout = dogCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: dogCardCollectionView.bounds.width * 0.8, height: dogCardCollectionView.bounds.height * 0.95)
            layout.minimumLineSpacing = (dogCardCollectionView.bounds.width - layout.itemSize.width) / 4
            layout.sectionInset = UIEdgeInsets(top: 0, left: layout.minimumLineSpacing * 2, bottom: 0, right: layout.minimumLineSpacing * 2)
        }
    }
    
    func presentImageCollectionViewControllerModally(breedName:String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "modalCollectionViewController") as? ModalCollectionViewController {
            interstitialLoadingView?.isHidden = false
            DogAPIManager.shared.getAllImageURLs(ofBreed: breedName) { urls in
                vc.imageURLs = urls
                vc.modalPresentationStyle = .overFullScreen
                DispatchQueue.main.async {
                    self.present(vc, animated: false, completion: nil)
                    self.interstitialLoadingView?.isHidden = true
                }
            }
        }
    }
}

extension BaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dogCardCollectionView {
            return modifiedCardData.count
        }
        if collectionView == favoriteCollectionView {
            return FavoriteBreedManager.shared.getFavorites().count
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
                cell.updateCell(withBreed: FavoriteBreedManager.shared.getFavorites()[indexPath.item], index: indexPath.item)
                cell.delegate = self
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

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
        print("delete pressed")
        FavoriteBreedManager.shared.removeFromFavorites(breedName: withBreed)
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (searchBar.text ?? "") + string
        if text == "" {
            print("emtpy")
            modifiedCardData = baseCardData
            return true
        }
        searchAndModify(string: text)
        DispatchQueue.main.async {
            self.dogCardCollectionView.reloadData()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // End editing on touch anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Search for string within the cards
    func searchAndModify(string:String) {
        var newData = [DogCardData]()
        // Change to map
        for data in baseCardData {
            if data.breedName.range(of: string, options: .caseInsensitive) != nil {
                newData.append(data)
            }
        }
        modifiedCardData = newData
    }
}
