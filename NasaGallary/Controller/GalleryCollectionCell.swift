//
//  GalleryCollectionCell.swift
//  NasaGallary
//
//  Created by Megha  on 26/01/23.
//

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgImage.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        contentView.layer.backgroundColor = UIColor(red: 174/255, green: 174/255, blue: 178/255, alpha: 1).cgColor
        
    }
}
