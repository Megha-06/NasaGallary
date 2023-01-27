//
//  ImageDetailCollectionCell.swift
//  NasaGallary
//
//  Created by Megha  on 26/01/23.
//

import UIKit

class ImageDetailCollectionCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgImage.layer.cornerRadius = 12
    }
}
