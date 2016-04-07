//
//  GDoubanDetailViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/30.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import MBProgressHUD
import ReactiveCocoa
import Kanna
import Kingfisher

class GDoubanDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var collection: UICollectionView!

    var parentImageUrlStr :NSMutableArray = []
   
    var curIndex:NSIndexPath?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        collection.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true;
      
        collection.registerClass(GGirlCollectionViewCell.self, forCellWithReuseIdentifier: "girlCell")
        backBtn.rac_command = RACCommand(signalBlock: { (any) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            return RACSignal.empty()
            
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.collection.delegate = self
            self.collection.dataSource = self
            if self.curIndex != nil
            {
            self.collection.scrollToItemAtIndexPath(self.curIndex!, atScrollPosition: .CenteredHorizontally, animated: false)
            }
        }
        
        
        
        
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.collection, animated: true)
        hud.labelText = "加载中..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.collection, animated: true)
    }
    
    // MARK: - Collection view data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentImageUrlStr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("girlCell", forIndexPath: indexPath) as! GGirlCollectionViewCell
        cell.girlsImageView.contentMode = .ScaleAspectFit
        cell.girlsImageView.kf_setImageWithURL(NSURL(string: parentImageUrlStr.objectAtIndex(indexPath.row) as! String)!)
    
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout method
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
    }
    
    //设置四周边距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0.0, 0)
    }
    
    //左右间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    //    上下间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    

}
