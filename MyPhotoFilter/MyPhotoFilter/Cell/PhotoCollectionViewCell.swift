//
//  PhotoCollectionViewCell.swift
//  MyPhotoFilter
//
//  Created by KDY on 2020/07/27.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Properties
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
