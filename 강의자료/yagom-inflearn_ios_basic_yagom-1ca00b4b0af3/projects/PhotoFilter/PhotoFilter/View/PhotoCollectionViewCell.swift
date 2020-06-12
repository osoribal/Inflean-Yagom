//
//  PhotoCollectionViewCell.swift
//  PhotoFilter
//
//  Created by yagom on 2017
//  Copyright © 2017년 yagom. All rights reserved.
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

