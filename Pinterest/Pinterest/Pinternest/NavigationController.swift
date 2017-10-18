//
//  NavigationController.swift
//  Pinterest
//
//  Created by nguyen ha on 10/17/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import UIKit
class NTNavigationController : UINavigationController{
    override func popViewController(animated: Bool) -> UIViewController
    {
        //viewWillAppearWithPageIndex
        let childrenCount = self.viewControllers.count
        let toViewController = self.viewControllers[childrenCount-2] as! NTWaterFallViewControllerProtocol
        let toView = toViewController.transitionCollectionView()
        let popedViewController = self.viewControllers[childrenCount-1] as! UICollectionViewController
        let popView  = popedViewController.collectionView!;
        let indexPath = popView.fromPageIndexPath()
        toViewController.viewWillAppearWithPageIndex(indexPath.row)
        toView?.setToIndexPath(indexPath)
        return super.popViewController(animated: animated)!
    }
    
}


