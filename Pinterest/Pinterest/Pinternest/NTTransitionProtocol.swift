//
//  NTTransitionProtocol.swift
//  Pinterest
//
//  Created by nguyen ha on 10/17/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import UIKit

@objc protocol NTTransitionProtocol{
    func transitionCollectionView() -> UICollectionView!
}

@objc protocol NTTansitionWaterfallGridViewProtocol{
    func snapShotForTransition() -> UIView!
}

@objc protocol NTWaterFallViewControllerProtocol : NTTransitionProtocol{
    func viewWillAppearWithPageIndex(_ pageIndex : NSInteger)
}

@objc protocol NTHorizontalPageViewControllerProtocol : NTTransitionProtocol{
    func pageViewCellScrollViewContentOffset() -> CGPoint
}
