 //
//  CommonFuncations.swift
//  Tul
//
//  Created by dev on 26/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreData
 
class CommonFuncations: NSObject {
  static  var loaderV = LoaderView()
 static func showAlertWithTitle(title : String,message : String) {
    let alertVc = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alertVc.addAction(UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        let currentVc = self.fetchCurrentViewController()
        currentVc.present(alertVc, animated: true, completion: nil)
        
    }
    static func fetchCurrentViewController()->UIViewController{
        let navCntrl = APPDELEGATE?.window?.rootViewController as! UINavigationController
        let currentVc = navCntrl.viewControllers.last!
        return currentVc
    }
    static func showLoader(show : Bool) {
        if show {
            
           // let currentVc = self.fetchCurrentViewController()
            if (!(APPDELEGATE?.window?.subviews.contains(loaderV))!)  {
                loaderV = UIView.loadFromNibNamedWithViewIndex("LoaderView", index: 0) as! LoaderView
                loaderV.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                loaderV.loadingView.startAnimating()
                loaderV.loadingView.isHidden=false
                APPDELEGATE?.window?.addSubview(loaderV)
            }
        }
        else{
            if loaderV.loadingView != nil{
            loaderV.loadingView.stopAnimating()
          loaderV.removeFromSuperview()
            }
        }
    }
    
    static func getCurrentYearAndFindDifference(strDate:String)->String{
        let date = Date()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date)
        
        let diff = (Int(year)) - (Int(strDate) ?? 0)
        return "\(diff) years ago"
    }
}
