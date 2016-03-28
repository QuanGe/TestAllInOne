//
//  GAdvDetailViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import MBProgressHUD
import ReactiveCocoa
import Kanna
class GAdvDetailViewController: UIViewController {

    var photos = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("splashAdvDetail")
        self.showLoadingHUD()
        let imageClick = NSUserDefaults.standardUserDefaults().objectForKey("appSplashClick") as? String
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:imageClick!)!)
       NSURLConnection.rac_sendAsynchronousRequest(request).subscribeNext({ (result) -> Void in
        
       

        let htmlData = (result as! RACTuple).second as! NSData
        let htmlStr = String(data: htmlData, encoding: NSUTF8StringEncoding)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            //用photos保存临时数据
          
            //用kanna解析html数据
            if let doc = Kanna.HTML(html: htmlStr!, encoding: NSUTF8StringEncoding){
                CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
               
                //解析imageurl
                for node in doc.css("img"){
                    let src = node["src"]! as String
                    
                    if (src.rangeOfString("icon") == nil)
                    {
                        self.photos.append(node["src"]!)
                    }
                    
                }
                
                NSLog("%@",self.photos )
                
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.hideLoadingHUD()
        }
        
         }, error: {
            (error) -> Void in
       
            dispatch_async(dispatch_get_main_queue()) {
                self.hideLoadingHUD()
            }
       })
    
    }

    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "加载中..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

}
