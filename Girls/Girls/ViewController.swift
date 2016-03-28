//
//  ViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/7.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    

    @IBOutlet weak var advImageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.gotoAppHome()
        }
        self.advImageview.userInteractionEnabled = true
        self.advImageview.contentMode = .ScaleAspectFill
        let dstPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
        let imageSavePath = (dstPath as NSString).stringByAppendingPathComponent("appSplashPath")
        if NSFileManager.defaultManager().fileExistsAtPath(imageSavePath)
        {
            self.advImageview.image = UIImage(contentsOfFile: imageSavePath)
        }
        
        self.advImageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "gotoAdvDetail:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func testCrash(sender: UIButton) {
       self.gotoAppHome()
    }
    
    func gotoAppHome()
    {
        if(self.view.tag != 111)
        {
            let main = UIStoryboard(name: "Main", bundle: nil);
            let modal=main.instantiateViewControllerWithIdentifier("GHomeViewController");
            self.navigationController?.pushViewController(modal, animated: false);
        }
    }
    
    func gotoAdvDetail(sender:UITapGestureRecognizer)
    {
        
        gotoAppHome()
        self.view.tag = 111;
    }

   
}

