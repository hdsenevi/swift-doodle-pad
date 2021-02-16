//
//  SketchCell.swift
//  DoodlePad
//
//  Created by Shanaka Senevirathne on 15/2/21.
//

import UIKit

class SketchCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            if let image = image {
                thumbnailImageView.image = image
            }
        }
    }
}
