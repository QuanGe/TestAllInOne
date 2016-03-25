//
//  GHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit

class GHomeViewController: UITabBarController,UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.delegate = self
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
