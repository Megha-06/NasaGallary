//
//  GalleryVC.swift
//  NasaGallary
//
//  Created by Megha  on 26/01/23.
//

import UIKit
import Kingfisher


class GalleryVC: UIViewController , UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  
    //MARK: - IBOutlets
    @IBOutlet weak var collectionGallery: UICollectionView!
    
    //MARK: - Variables
    var arrGalleryData : [GetGalleryImageModel]?
    let animationDuration: Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    func setupUI(){
        registerNibs()
        uiInitialization()
    }
    
    func uiInitialization(){
        collectionGallery.delegate = self
        collectionGallery.dataSource = self
        let json = readLocalFile(forName: "data")
        parse(jsonData: json!)
        self.navigationController?.delegate = self

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionGallery.collectionViewLayout.invalidateLayout()
    }
    
  //MARK: - Xib registration
    func registerNibs(){
        collectionGallery.register(UINib.init(nibName: "GalleryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionCell")
    }
}

//MARK: - Collectionview datasource & Delegates
extension GalleryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGalleryData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      UIView.animate(withDuration: animationDuration) {
        cell.alpha = 1
        cell.transform = .identity
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionGallery.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionCell", for: indexPath) as! GalleryCollectionCell
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let dict = arrGalleryData?[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var column: CGFloat
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight{
            column = 6
        }
        else{
            column = 3
        }
        
        //Match spacing below
        let spacing : CGFloat = 5
        let totalHorizontalSpacing = (column - 1) * spacing
        let itemWidth = (collectionGallery.bounds.width - totalHorizontalSpacing) / column
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = arrGalleryData?[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDetailVC") as? ImageDetailVC
        vc?.arrGalleryData = arrGalleryData
        vc?.selectedIndex = indexPath.row
        vc?.selectedIndexPath = indexPath
        vc?.selectedData = dict
        UIView.animate(withDuration: 0.45, animations: { () -> Void in
            UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
            self.navigationController!.pushViewController(vc!, animated: false)
            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        })
    }


}

//MARK: - Load json Data
extension GalleryVC{
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([GetGalleryImageModel].self,
                                                       from: jsonData)
            arrGalleryData = decodedData
            print("===================================")
        } catch {
            print("decode error")
        }
    }
}
