//
//  InterstitialLoadingView.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 2/7/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit

class InterstitialLoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = UIColor.clear
        setupBlurView()
        setupIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIndicator() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        addSubview(indicator)
        indicator.center = center
        indicator.startAnimating()
    }
    
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
}
