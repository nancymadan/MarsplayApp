//
//  ApiRequest.swift
//  Tul
//
//  Created by dev on 25/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import Alamofire


enum ApiMethod {
    case GET
    case POST
}
class ApiRequest: NSObject {
    
    
    static func callApiWithParameters(url: String , withParameters parameters:[String:AnyObject], success:@escaping ([Search])->(), failure: @escaping (NSString)->(), method: ApiMethod, img: UIImage? , imageParamater: String,headers: [String:String]){
        let manager = Alamofire.SessionManager.default
       // manager.session.configuration.timeoutIntervalForRequest = 30
        switch method {
        case .GET:
            manager.request(url ,method : .get,parameters:parameters,encoding:URLEncoding.httpBody ,headers: headers).responseJSON { response
                in
                let statusCode = response.response?.statusCode
                switch response.result{
                    
                case .success(_):
                    if(statusCode==200){
                        if let value = response.result.value{
                            let dict=value as? NSDictionary
                            if dict != nil && dict?.value(forKey: "Error") != nil{
                                failure(dict!.value(forKey: "Error") as! NSString)
                                return
                            }
                            
                        }
                        if let data = response.data{
                            do{
                         let json = try JSONDecoder().decode(Welcome.self, from: data)
                            success(json.search)
                            }
                            catch let error as NSError {
                                print("Could not save\(error),\(error.userInfo)")
                            }
                        }
                    }
                    else{
                        if let data = response.result.value{
                            let dict=data as! NSDictionary
                            failure(dict.value(forKey: "error_description") as! NSString)
                        }
                        else if let error = response.result.error{
                            failure(error.localizedDescription as NSString)
                        }
                    }
                    break
                case .failure(_):
                    if let error = response.result.error{
                        let str = error.localizedDescription as NSString
                        if str.isEqual(to: "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
                            return
                        }
                        
                        failure(error.localizedDescription as NSString)
                    }
                    
                }
            }
            break
        case .POST:
            
            manager.request( url, method : .post, parameters:parameters,encoding: JSONEncoding.default,headers: headers).responseJSON {
                response in
                let statusCode = response.response?.statusCode
                switch response.result{
                    
                case .success(_):
                    if(statusCode==200){
                        if let data = response.data{
                            do{
                                let json = try JSONDecoder().decode(Welcome.self, from: data)
                                success(json.search)
                            }
                            catch let error as NSError {
                                print("Could not save\(error),\(error.userInfo)")
                            }
                        }
                    }
                    else{
                        if let data = response.result.value{
                            let dict=data as! NSDictionary
                            failure(dict.value(forKey: "error_description") as! NSString)
                        }
                        else if let error = response.result.error{
                            failure(error.localizedDescription as NSString)
                        }
                    }
                    break
                    
                case .failure(_):
                    if let error = response.result.error{
                        failure(error.localizedDescription as NSString)
                    }
                }}
            break
       
        }
    }
    
}
