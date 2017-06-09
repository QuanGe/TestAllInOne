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
        self.navigationController?.isNavigationBarHidden = true;
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.gotoAppHome()
        }
        self.advImageview.isUserInteractionEnabled = true
        self.advImageview.contentMode = .scaleAspectFill
        let dstPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let imageSavePath = (dstPath as NSString).appendingPathComponent("appSplashPath")
        if FileManager.default.fileExists(atPath: imageSavePath)
        {
            self.advImageview.image = UIImage(contentsOfFile: imageSavePath)
        }
        
        self.advImageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.gotoAdvDetail(_:))))
        MobClick.event("splashVC")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func testCrash(_ sender: UIButton) {
       self.gotoAppHome()
    }
    
    func gotoAppHome()
    {
        if(self.view.tag != 111)
        {
            let main = UIStoryboard(name: "Main", bundle: nil);
            let modal=main.instantiateViewController(withIdentifier: "GHomeViewController");
            self.navigationController?.pushViewController(modal, animated: false);
        }
    }
    
    func gotoAdvDetail(_ sender:UITapGestureRecognizer)
    {
        
        gotoAppHome()
        self.view.tag = 111;
    }

   
}

