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
        MobClick.event("appHome")
        Alamofire.request(.GET, "https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/launchImage").validate().responseString { (request, response,result) in
            if result.isFailure
            {
                return
            }
            NSLog(result.value!)
            let strs = result.value?.components(separatedBy: " ")
            let imageUrl = strs?.first;
            let imageClick = strs?.last
            
            let imageSaveUrl = UserDefaults.standard.object(forKey: "appSplashUrl") as? String
            if (imageSaveUrl == imageUrl && imageSaveUrl != nil)
            {
                return
            }
            
            
            
            Alamofire.request(.GET,imageUrl!).validate().responseData{
                (request, response,result) in
                let imagedata = result.value
                let dstPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
                let imageSavePath = (dstPath as NSString).appendingPathComponent("appSplashPath")
                
                if FileManager.default.createFile(atPath: imageSavePath, contents: imagedata, attributes: nil) {
                    UserDefaults.standard.set(imageUrl, forKey: "appSplashUrl")
                    UserDefaults.standard.set(imageClick, forKey: "appSplashClick")
                }
                
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let childs =  self.childViewControllers as NSArray
        for vc in childs
        {
            if vc is GQiuShiHomeViewController
            {
                (vc as? UIViewController)!.tabBarItem.image = UIImage(named: "icon_main")?.withRenderingMode(.alwaysOriginal)
                (vc as? UIViewController)!.tabBarItem.selectedImage = UIImage(named: "icon_main_active")?.withRenderingMode(.alwaysOriginal)
            }
            else
            {
                (vc as? UIViewController)!.tabBarItem.image = UIImage(named: "icon_me")?.withRenderingMode(.alwaysOriginal)
                (vc as? UIViewController)!.tabBarItem.selectedImage = UIImage(named: "icon_me_active")?.withRenderingMode(.alwaysOriginal)

            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
       
        let frontVc = self.navigationController?.childViewControllers[0]
        let nav:GNavigationController = self.navigationController as! GNavigationController
        
        nav.resetDelegate()
        
        if(frontVc!.view.tag==111)
        {
            let main = UIStoryboard(name: "Main", bundle: nil);
            let modal=main.instantiateViewController(withIdentifier: "GAdvDetailViewController");
            self.navigationController?.pushViewController(modal, animated: false);
        }
    }
   
}
