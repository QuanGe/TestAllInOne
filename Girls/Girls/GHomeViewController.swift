//
//  GHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import Alamofire
class GHomeViewController: UITabBarController,UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.delegate = self
        
        Alamofire.request(.GET, "https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/launchImage").validate().responseString { response in
            NSLog(response.result.value!)
            let strs = response.result.value?.componentsSeparatedByString(" ")
            let imageUrl = strs?.first;
            let imageSaveUrl = NSUserDefaults.standardUserDefaults().objectForKey("appSplashUrl") as? String
            if (imageSaveUrl == imageUrl && imageSaveUrl != nil)
            {
                return
            }
            
            
            
            Alamofire.request(.GET,imageUrl!).validate().responseString{
                respon in
                let imagedata = respon.data
                let dstPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
                let imageSavePath = (dstPath as NSString).stringByAppendingPathComponent("appSplashPath")
                
                if NSFileManager.defaultManager().createFileAtPath(imageSavePath, contents: imagedata, attributes: nil) {
                    NSUserDefaults.standardUserDefaults().setObject(imageUrl, forKey: "appSplashUrl")
                }
                
            }
        }
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem?.customView?.hidden = true;
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
       
        let frontVc = self.navigationController?.childViewControllers[0]
        let nav:GNavigationController = self.navigationController as! GNavigationController
        
        nav.resetDelegate()
        
        if(frontVc!.view.tag==111)
        {
            let main = UIStoryboard(name: "Main", bundle: nil);
            let modal=main.instantiateViewControllerWithIdentifier("GAdvDetailViewController");
            self.navigationController?.pushViewController(modal, animated: false);
        }
    }
   
}
