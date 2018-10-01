//
//  MarsplayDetailViewController.swift
//  Marsplay
//
//  Created by Abhishek Rana on 30/09/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit
import IDMPhotoBrowser
class MarsplayDetailViewController: UIViewController {
    var viewModelMarsplay : MarsplayViewModel? = nil
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate=self
        self.navigationController?.navigationBar.isHidden = true
        self.addNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name:UIDevice.orientationDidChangeNotification, object: nil)
    }
    func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func rotated() {
        self.navigationController?.navigationBar.isHidden = true

    }
    func setData(){
        self.imgMovie.sd_setImage(with: URL.init(string: viewModelMarsplay?.poster ?? "")) { (image, error, type, url) in
            
        }
        self.lblTime.text = CommonFuncations.getCurrentYearAndFindDifference(strDate:viewModelMarsplay?.year ?? "")
        self.lblTitle.text = viewModelMarsplay?.title ?? ""
        self.lblType.text = viewModelMarsplay?.type.rawValue
    }
    
    @IBAction func actionImageTap(_ sender: Any) {
        let browser = IDMPhotoBrowser.init(photoURLs: [self.viewModelMarsplay?.poster ?? ""])
        browser?.scaleImage = self.imgMovie.image
        self.present(browser!, animated: true, completion: nil)
    }
    @IBAction func actionback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension MarsplayDetailViewController:UINavigationControllerDelegate,RMPZoomTransitionAnimating,RMPZoomTransitionDelegate,UIGestureRecognizerDelegate{
    func zoomTransitionAnimator(_ animator: RMPZoomTransitionAnimator, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView) {
       
        
    }
    func transitionSourceBackgroundColor() -> UIColor {
        return   self.view.backgroundColor!
    }
    
    
    func transitionSourceImageView() -> UIImageView {
        let rect = self.imgMovie.convert(self.imgMovie.bounds, to: self.view)
        let imageView = UIImageView.init(frame:rect)
        imageView.image = self.imgMovie.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    func transitionDestinationImageViewFrame() -> CGRect {
        var rect = self.imgMovie.frame
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
        rect.size.width = ScreenWidth
        rect.size.height = ScreenWidth*0.8
        }
//        var topPadding : CGFloat = 0.0
//        if #available(iOS 11.0, *) {
//            topPadding = (self.view.safeAreaInsets.top)
//        }
        rect.origin.y = rect.origin.y + 20
        return rect
    }
   
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = RMPZoomTransitionAnimator()
        animator.goingForward = (operation == UINavigationController.Operation.push || operation == UINavigationController.Operation.pop)
        animator.sourceTransition = self
        animator.destinationTransition = toVC as? RMPZoomTransitionAnimating & RMPZoomTransitionDelegate
        return animator
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        
            return true
        
    }
}
