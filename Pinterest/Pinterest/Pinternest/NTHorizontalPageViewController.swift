//
//  NTHorizontalPageViewController.swift
//  Pinterest
//
//  Created by nguyen ha on 10/17/17.
//  Copyright © 2017 Ace. All rights reserved.
//


import Foundation
import UIKit

let horizontalPageViewCellIdentify = "horizontalPageViewCellIdentify"

class NTHorizontalPageViewController : UICollectionViewController, NTTransitionProtocol ,NTHorizontalPageViewControllerProtocol{
    
    var images: [UIImage] = []
    var pullOffset = CGPoint.zero
    
    init(collectionViewLayout layout: UICollectionViewLayout!, currentIndexPath indexPath: IndexPath){
        super.init(collectionViewLayout:layout)
        let collectionView :UICollectionView = self.collectionView!;
        collectionView.isPagingEnabled = true
        collectionView.register(NTHorizontalPageViewCell.self, forCellWithReuseIdentifier: horizontalPageViewCellIdentify)
        collectionView.setToIndexPath(indexPath)
        collectionView.performBatchUpdates({collectionView.reloadData()}, completion: { finished in
            if finished {
                collectionView.scrollToItem(at: indexPath,at:.centeredHorizontally, animated: false)
            }});
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell: NTHorizontalPageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: horizontalPageViewCellIdentify, for: indexPath) as! NTHorizontalPageViewCell
        collectionCell.image = self.images[indexPath.row]
        collectionCell.tappedAction = {}
        collectionCell.pullAction = { offset in
            self.pullOffset = offset
            self.navigationController!.popViewController(animated: true)
        }
        collectionCell.setNeedsLayout()
        return collectionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return images.count
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    func pageViewCellScrollViewContentOffset() -> CGPoint{
        return self.pullOffset
    }
}

