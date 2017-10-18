//
//  imageCell.swift
//  Pinterest
//
//  Created by nguyen ha on 10/17/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import UIKit

class imageCell: UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    
    
    @IBOutlet weak var xrimageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderUI()
    }
    
    func updateUI(imageName: String) {
        if let image = UIImage(named: imageName) {
            xrimageview.image = image
        }
    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.xrimageview.image)
        snapShotView.frame = xrimageview.frame
        return snapShotView
    }
}
