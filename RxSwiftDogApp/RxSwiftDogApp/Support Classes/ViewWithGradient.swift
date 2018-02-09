//
//  ViewWithGradient.swift
//  VerticalNavigationExample
//
//  Created by Leo Tsuchiya on 12/15/17.
//  Copyright © 2017 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit

// Needed to get CALayers to work with auto layout resizing frame
class ViewWithGradient: UIView {
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                layer.frame = self.bounds
            }
        }
    }
}
