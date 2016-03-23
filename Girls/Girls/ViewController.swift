//
//  ViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/7.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
class ViewController: UIViewController {
    
    
    @IBOutlet weak var girlsPhotos: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       girlsPhotos.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func testCrash(sender: UIButton) {
        //let image:UIImageView = self.view.viewWithTag(1000) as! UIImageView;
        //image.image = UIImage(named: "icon_feeds_active");
        
        Crashlytics.sharedInstance().crash();
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 20;
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("girlsPhotosCell", forIndexPath: indexPath)
        let image:UIImageView = cell.viewWithTag(10) as! UIImageView;
        image.image = UIImage(named: "icon_feeds_active");
        
        return  cell;
        
        
    }
    
 
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        
        return 1;
    }

}

