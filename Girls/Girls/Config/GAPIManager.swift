//
//  GAPIManager.swift
//  Girls
//
//  Created by 张如泉 on 16/3/29.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire
import Mantle

public enum RequestType
{
    case GRequestTypeString,GRequestTypeJson,GRequestTypeData
}

class GAPIManager: NSObject {
    static let sharedInstance = GAPIManager()
    
    func fetchData(urlstring:String,type:RequestType,params:NSDictionary,header:NSDictionary,httpMethod:String) -> RACSignal {
        
        return RACSignal.createSignal({ ( subscriber) -> RACDisposable! in
            
            var request : Request!
          
            if type == .GRequestTypeJson
            {
                request =  Alamofire.request(httpMethod == "get" ?.GET:.POST, urlstring, parameters: params as? [String : AnyObject], encoding: .URL, headers: header as? [String : String]).responseJSON(completionHandler: { (request, response, result) -> Void in
                    if(result.isFailure)
                    {
                        subscriber.sendError(result.error as! NSError)
                        
                    }
                    else
                    {
                        subscriber.sendNext(result.value)
                        subscriber.sendCompleted()
                    }
                })
            }
            else if type == .GRequestTypeString
            {
                request =  Alamofire.request(httpMethod == "get" ?.GET:.POST, urlstring, parameters: params as? [String : AnyObject], encoding: .URL, headers: header as? [String : String]).responseString(completionHandler: { (request, response, result) -> Void in
                    if(result.isFailure)
                    {
                        subscriber.sendError(result.error as! NSError)
                        
                    }
                    else
                    {
                        subscriber.sendNext(result.value)
                        subscriber.sendCompleted()
                    }
                })
            }
            else if type == .GRequestTypeData
            {
                request =  Alamofire.request(httpMethod == "get" ?.GET:.POST, urlstring, parameters: params as? [String : AnyObject], encoding: .URL, headers: header as? [String : String]).responseData({ (request, response, result) -> Void in
                    if(result.isFailure)
                    {
                        subscriber.sendError(result.error as! NSError)
                        
                    }
                    else
                    {
                        subscriber.sendNext(result.value)
                        subscriber.sendCompleted()
                    }
                })
            }

            return RACDisposable(block: { () -> Void in
                request.cancel()
            })
        })
    }
    
    func fetchQiuBaiHot(pagenum:Int)-> RACSignal{
        return fetchData("http://m2.qiushibaike.com/article/list/suggest",type: .GRequestTypeJson,params: ["count":"40","page":pagenum],header: [:],httpMethod: "get").map({ (result) -> AnyObject! in
            let items = result["items"] as! [AnyObject]
            do {
                return try MTLJSONAdapter.modelsOfClass(GQiuBaiModel.self, fromJSONArray: items)
            } catch {
                
                return nil
            }
           
        })
    }
    
}
