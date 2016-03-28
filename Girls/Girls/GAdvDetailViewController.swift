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

class GAdvDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("splashAdvDetail")
        self.showLoadingHUD()
        let imageClick = NSUserDefaults.standardUserDefaults().objectForKey("appSplashClick") as? String
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:imageClick!)!)
       NSURLConnection.rac_sendAsynchronousRequest(request).subscribeNext({ (result) -> Void in
        
       

        let htmlData = (result as! RACTuple).second as! NSData
        let htmlStr = String(data: htmlData, encoding: NSUTF8StringEncoding)
       
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
