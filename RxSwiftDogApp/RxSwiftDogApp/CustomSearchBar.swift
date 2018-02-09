//
//  CustomSearchBar.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 2/8/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import UIKit

class CustomSearchBar: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let padding:CGFloat = 10
        let side:CGFloat = bounds.height * 0.7
    
        let outerView = UIView(frame: CGRect(x: padding, y: 0, width: side + padding, height: side))
        leftView = outerView
        leftViewMode = .always
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Search Icon"))
        imageView.frame = CGRect(x: padding, y: 0, width: side, height: side)
        outerView.addSubview(imageView)
        autocorrectionType = .no
    }
}
