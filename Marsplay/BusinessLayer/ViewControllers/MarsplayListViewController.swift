//
//  MarsplayListViewController.swift
//  Marsplay
//
//  Created by Abhishek Rana on 30/09/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import SDWebImage
import LoadingPlaceholderView
class MarsplayListViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var DataLoaded = false
    var selectedImageView = UIImageView()
    var selectedImageFrame = CGRect.zero
    private var loadingPlaceholderView = LoadingPlaceholderView()
    var page = 1
    var arrList = [MarsplayViewModel]()
    @IBOutlet weak var collList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
        self.addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.navigationController?.delegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK:-Helper
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name:UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func rotated() {
        
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft{
        self.collList.reloadData()
        }
    }
    func setUp(){
      
        self.getData()
        //infinteSCroll
        self.collList.addInfiniteScrolling {
            self.collList.infiniteScrollingView.startAnimating()
          self.getData()
        }
    }
    func getData(){
//        loadingPlaceholderView.gradientColor = .darkGray
//        loadingPlaceholderView.backgroundColor = .lightGray
        loadingPlaceholderView.cover(self.collList)
        MarsplayViewModel.getTheList(for: page) { (arrS) in
            self.collList.infiniteScrollingView.stopAnimating()

            self.DataLoaded = true
            
            if self.page == 1{
            self.arrList = arrS
            }
            else{
                self.arrList.append(contentsOf: arrS)
            }
            self.perform(#selector(self.delay), with: nil, afterDelay: 0)
            if arrS.count != 0{
                self.page = self.page + 1
            }
        }
        
        
        
    }
    @objc func delay(){
        self.loadingPlaceholderView.uncover()

       self.collList.reloadData()
    }
 

    /**UICollectionview data source and delegate
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataLoaded ? arrList.count : 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarsplayCollectionViewCell", for: indexPath) as! MarsplayCollectionViewCell
        if DataLoaded{
        let mm = arrList[indexPath.row]
        cell.imgPoster.sd_setImage(with: URL.init(string: mm.poster)) { (image, error, type, url) in
            
        }
        cell.lblDate.text = CommonFuncations.getCurrentYearAndFindDifference(strDate:mm.year)
        cell.lblTitle.text = mm.title
        cell.lblType.text = mm.type.rawValue
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collSize = self.collList.frame.size
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            let width = collSize.width/3-10
            let height = collSize.width/3-10 + 3*21 + 3*8 + 20
            return CGSize.init(width:width, height: height+32)
      
        }
        else if UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown{
            if collSize.width > collSize.height{
                let width = collSize.width/3-10
                let height = collSize.width/3-10 + 3*21 + 3*8 + 20
                return CGSize.init(width:width, height: height+32)
            }
            else{
                let width = collSize.width/2-10
                let height = collSize.width/2-10 + 3*21 + 3*8 + 20
                return CGSize.init(width:width, height: height+32)
            }
        }
        else{
            let collSize = self.collList.frame.size
            let width = collSize.width/2-10
            let height = collSize.width/2-10 + 3*21 + 3*8 + 20
            return CGSize.init(width:width, height: height+32)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MarsplayCollectionViewCell
        var topPadding : CGFloat = 20.0
        if #available(iOS 11.0, *) {
            topPadding = (self.view.safeAreaInsets.top)
        }
        let rect = cell.imgPoster.convert(cell.imgPoster.bounds, to: self.view)
        selectedImageFrame = rect
        //selectedImageFrame.origin.y += topPadding
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarsplayDetailViewController") as! MarsplayDetailViewController
        vc.viewModelMarsplay =  arrList[indexPath.row]
    selectedImageView = cell.imgPoster
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MarsplayListViewController :  UINavigationControllerDelegate,RMPZoomTransitionAnimating,RMPZoomTransitionDelegate {
    func zoomTransitionAnimator(_ animator: RMPZoomTransitionAnimator, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView) {
    }
    
    func transitionSourceBackgroundColor() -> UIColor {
        return   self.view.backgroundColor!
    }
    
    
    func transitionSourceImageView() -> UIImageView {
        let imageView = UIImageView.init(frame: selectedImageFrame)
        imageView.image = selectedImageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    func transitionDestinationImageViewFrame() -> CGRect {
        return  selectedImageFrame
    }
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = RMPZoomTransitionAnimator()
        animator.goingForward =  (operation == UINavigationController.Operation.push || operation == UINavigationController.Operation.pop)
        animator.sourceTransition = self
        
        animator.destinationTransition = toVC as?  RMPZoomTransitionAnimating & RMPZoomTransitionDelegate
        return animator
    }
}
