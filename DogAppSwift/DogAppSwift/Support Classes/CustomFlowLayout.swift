//
//  CustomFlowLayout.swift
//  DogAppSwift
//
//  Created by Leo Tsuchiya on 1/23/18.
//  Copyright © 2018 Leo Tsuchiya. All rights reserved.
//

import Foundation
import UIKit


// Custom flow layout for special transition effects
// Assigned to the flowLayout property of UICollectionViews
class CustomFlowLayout: UICollectionViewFlowLayout {
    
    init(scrollDirection:UICollectionViewScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // Return true so that the layout will be recalculated when scrolled
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // Paging
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView, !collectionView.isPagingEnabled, let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        let midPoint = self.scrollDirection == .vertical ? collectionView.bounds.size.height / 2 : collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = self.scrollDirection == .vertical ? proposedContentOffset.y + midPoint : proposedContentOffset.x + midPoint
        var targetContentOffset: CGPoint
        if self.scrollDirection == .vertical {
            let closest = layoutAttributes.sorted{abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin)}.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midPoint))
        }
            
        else {
            let closest = layoutAttributes.sorted{abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)}.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midPoint), y: proposedContentOffset.y)
        }
        
        return targetContentOffset
    }
}
