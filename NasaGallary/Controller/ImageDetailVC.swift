//
//  ImageDetailVC.swift
//  NasaGallary
//
//  Created by Megha  on 26/01/23.
//

import UIKit
import Kingfisher

class ImageDetailVC: UIViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionImageDetail: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - Variables
    var arrGalleryData : [GetGalleryImageModel]?
    var selectedIndex : Int!
    var selectedIndexPath : IndexPath!
    var selectedData : GetGalleryImageModel?
    
    //MARK: - Custum Collection setup
    let columnLayouttbanner = CustomCollection(
        cellsPerRow: 1,
        minimumInteritemSpacing: 0,
        minimumLineSpacing: 0,
        sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        collectionImageDetail?.collectionViewLayout = columnLayouttbanner
        collectionImageDetail?.contentInsetAdjustmentBehavior = .always
        collectionImageDetail?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        if let layout = collectionImageDetail.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        registerNibs()
        uiInitialization()
    }
    
    
    func uiInitialization(){
        collectionImageDetail.delegate = self
        collectionImageDetail.dataSource = self
        lblTitle.text = "NASA"
        let pageSize = self.view.bounds.size
        let contentOffset = CGPoint(x: Int(pageSize.width-12) * self.arrGalleryData!.count, y: 0)
        self.collectionImageDetail.setContentOffset(contentOffset, animated: false)
        
    }
    
    //MARK: - Xib registration
    func registerNibs(){
        collectionImageDetail.register(UINib.init(nibName: "ImageDetailCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageDetailCollectionCell")
    }
    
    //MARK: - IBActions
    @IBAction func btnBack(_ sender: Any) {
        UIView.animate(withDuration: 0.45, animations: { () -> Void in
            UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
            self.navigationController?.popViewController(animated: true)
            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
        })
    }
    
    override func viewDidLayoutSubviews() {
        collectionImageDetail.scrollToItem(at:IndexPath(item: selectedIndex, section: 0), at: .right, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionImageDetail.collectionViewLayout.invalidateLayout()
    }
    
    
    //MARK: - Scrollview Functions
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionImageDetail.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionImageDetail.scrollToNearestVisibleCollectionViewCell()
        }
    }
}


//MARK: - Collectionview datasource & Delegates
extension ImageDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGalleryData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionImageDetail.dequeueReusableCell(withReuseIdentifier: "ImageDetailCollectionCell", for: indexPath) as! ImageDetailCollectionCell
        let dict = arrGalleryData?[indexPath.row]
        cell.lblTitle.text = dict?.title
        cell.lblDescription.text = dict?.explanation
        cell.lblDate.text = "Posted on:\(dict?.date ?? "")"
        DispatchQueue.main.async {
            let dictPosterImage = dict?.url
            let activityInd = UIActivityIndicatorView()
            activityInd.center = CGPoint(x: cell.imgImage.frame.size.width  / 2,
                                         y: cell.imgImage.frame.size.height / 2)
            activityInd.color = UIColor.gray
            cell.imgImage.addSubview(activityInd)
            activityInd.startAnimating()
            if let url = URL.init(string: dictPosterImage ?? ""){
                KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    cell.imgImage.image = image
                    activityInd.stopAnimating()
                })
            }
        }
        return cell
    }
}
