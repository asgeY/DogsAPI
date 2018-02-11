//
//  ViewController.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/22/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    var baseCardData = Variable<[DogCardData]>([])
    var modifiedCardData = [DogCardData]()
    var interstitialLoadingView:InterstitialLoadingView?
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var dogCardCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
        setupInterstitialLoadingView()
        downloadDogCardData()
        setupCollectionViews()
        
        // Setup the delegate for dismissal
        searchBar.delegate = self
    }
    
    // Bind observables and ui objects
    private func setupRx() {
        // React to search bar text input
        searchBar.rx.text
            .orEmpty
            .subscribe({ event in
                if let text = event.element {
                    self.searchTextModified(to: text)
                }
            })
            .disposed(by: disposeBag)
        
        // React to dog data being downloaded and stop showing loading
        baseCardData.asObservable().take(2).skip(1)
            .subscribe({ event in
                if event.isCompleted {
                    DispatchQueue.main.async {
                        self.dogCardCollectionView.reloadData()
                        self.interstitialLoadingView?.isHidden = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // React to favorites being modified
        
        // React to downloading of new modal data
    }
    
    private func setupInterstitialLoadingView() {
        let interView = InterstitialLoadingView(frame: view.bounds)
        view.addSubview(interView)
        interstitialLoadingView = interView
    }
    
    // Download all breed names and populate the data array
    private func downloadCardData() {
        DogAPIManager.shared.getAllBreedNames() { breeds in
            if let breeds = breeds {
                let newData = breeds.map({
                    return DogCardData(breedName: $0)
                })
                self.baseCardData.value = newData
                self.modifiedCardData = newData
            }
        }
    }
    
    private func setupCollectionViews() {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCollectionViewItemSizes()
    }
    
    private func setupCardFlowLayout() {
        let layout = CustomFlowLayout(scrollDirection: .horizontal)
        dogCardCollectionView.collectionViewLayout = layout
    }
    private func setupFavoriteFlowLayout() {
        let layout = CustomFlowLayout(scrollDirection: .horizontal)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        favoriteCollectionView.collectionViewLayout = layout
    }
    private func setCollectionViewItemSizes() {
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
    
    private func presentImageCollectionViewControllerModally(breedName:String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "modalCollectionViewController") as? ModalCollectionViewController {
            // Show interestitial loading while waiting for response
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
