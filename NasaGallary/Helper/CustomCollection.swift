//
//  CustomCollection.swift
//  NasaGallary
//
//  Created by Megha  on 26/01/23.
//

import Foundation
import UIKit
class CustomCollection: UICollectionViewFlowLayout {

        let cellsPerRow: Float

        init(cellsPerRow: Float, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
            self.cellsPerRow = cellsPerRow
            super.init()

            self.minimumInteritemSpacing = minimumInteritemSpacing
            self.minimumLineSpacing = minimumLineSpacing
            self.sectionInset = sectionInset
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func prepare() {
            super.prepare()

            guard let collectionView = collectionView else { return }
            let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - 13) / CGFloat(cellsPerRow)).rounded(.down)
            itemSize = CGSize(width: itemWidth, height: collectionView.bounds.height)
        }

        override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
            let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
            context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
            return context
        }

    }
