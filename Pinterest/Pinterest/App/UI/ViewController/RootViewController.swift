//
//  RootViewController.swift
//  Pinterest
//
//  Created by nguyen ha on 10/17/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import BSImagePicker
import Photos

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        let fromVCConfromA = (fromVC as? NTTransitionProtocol)
        let fromVCConfromB = (fromVC as? NTWaterFallViewControllerProtocol)
        let fromVCConfromC = (fromVC as? NTHorizontalPageViewControllerProtocol)
        
        let toVCConfromA = (toVC as? NTTransitionProtocol)
        let toVCConfromB = (toVC as? NTWaterFallViewControllerProtocol)
        let toVCConfromC = (toVC as? NTHorizontalPageViewControllerProtocol)
        if((fromVCConfromA != nil)&&(toVCConfromA != nil)&&(
            (fromVCConfromB != nil && toVCConfromC != nil)||(fromVCConfromC != nil && toVCConfromB != nil))){
            let transition = NTTransition()
            transition.presenting = operation == .pop
            return  transition
        }else{
            return nil
        }
        
    }
}

class RootViewController: PrimaryViewController, NTTransitionProtocol, NTWaterFallViewControllerProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [UIImage] = []
    let delegateHolder = NavigationControllerDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TIME LINE"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PHOTO", style: .plain, target: self, action:  #selector(openAlbum))
        self.navigationController!.delegate = delegateHolder
        
        collectionView.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collectionView.backgroundColor = Const.colorWhite
        collectionView.register(UINib(nibName: "imageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        collectionView.reloadData()
    }

    @objc func openAlbum() {
        let vc = BSImagePickerViewController()
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            self.reloadData(assets: assets)
        }, completion: nil)
    }
    
    func reloadData(assets: [PHAsset]) {
        DispatchQueue.main.async(execute: {
            for obj in assets {
                self.images.append(self.getThumbnail(asset: obj)!)
            }
            self.collectionView.reloadData()
        })
    }
    
    func getThumbnail(asset: PHAsset) -> UIImage? {
        var thumbnail: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                thumbnail = UIImage(data: data)
            }
        }
        return thumbnail
    }
    
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let image: UIImage! = images[indexPath.row]
        let imageHeight = image.size.height * gridWidth/image.size.width
        return CGSize(width: gridWidth, height: imageHeight)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell: imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCell
        collectionCell.xrimageview.image = self.images[indexPath.row]
        collectionCell.setNeedsLayout()
        return collectionCell
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return images.count
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageViewController =
            NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        pageViewController.images = images
        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
    }
    
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize  = self.navigationController!.isNavigationBarHidden ?
            CGSize(width: screenWidth, height: screenHeight+20) : CGSize(width: screenWidth, height: screenHeight-navigationHeaderAndStatusbarHeight)
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
    
    func viewWillAppearWithPageIndex(_ pageIndex: NSInteger) {
        var position: UICollectionViewScrollPosition =
            UICollectionViewScrollPosition.centeredHorizontally.intersection(.centeredVertically)
        let image: UIImage! = self.images[pageIndex]
        let imageHeight = image.size.height*gridWidth/image.size.width
        if imageHeight > 400 {//whatever you like, it's the max value for height of image
            position = .top
        }
        let currentIndexPath = IndexPath(row: pageIndex, section: 0)
        let collectionView = self.collectionView!;
        collectionView.setToIndexPath(currentIndexPath)
        if pageIndex < 2 {
            collectionView.setContentOffset(CGPoint.zero, animated: false)
        } else {
            collectionView.scrollToItem(at: currentIndexPath, at: position, animated: false)
        }
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
}

