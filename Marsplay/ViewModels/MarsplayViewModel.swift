//
//  MarsplayViewModel.swift
//  Marsplay
//
//  Created by Abhishek Rana on 30/09/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import UIKit

class MarsplayViewModel: NSObject {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String
    
    init(model:Search) {
        self.title = model.title
        self.year = model.year
        self.imdbID = model.imdbID
        self.type = model.type
        self.poster = model.poster
    }
    
    static func getTheList(for Page : Int, success:@escaping ([MarsplayViewModel])->()){
   // CommonFuncations.showLoader(show: true)
        ApiRequest.callApiWithParameters(url: "http://www.omdbapi.com/?s=Batman&page=\(Page)&apikey=eeefc96f", withParameters: [:], success: { (arrSearch) in
          //  CommonFuncations.showLoader(show: false)
            var mM = [MarsplayViewModel]()
            for m in arrSearch{
                mM.append(MarsplayViewModel.init(model: m))
            }
            
            success(mM)
        }, failure: { (error) in
          //  CommonFuncations.showLoader(show: false)
            CommonFuncations.showAlertWithTitle(title: "Error", message: error as String)

        }, method: .GET, img: nil, imageParamater: "", headers: [:])
    }
}
