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
   
    var curIndex:IndexPath?
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
        self.view.backgroundColor = UIColor.white
        collection.backgroundColor = UIColor.white
        
      
        collection.register(GGirlCollectionViewCell.self, forCellWithReuseIdentifier: "girlCell")
        backBtn.rac_command = RACCommand(signalBlock: { (any) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            return RACSignal.empty()
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.collection.delegate = self
            self.collection.dataSource = self
            if self.curIndex != nil
            {
            self.collection.scrollToItem(at: self.curIndex!, at: .centeredHorizontally, animated: false)
            }
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.tabBarController?.qgocc_isTabBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
       
    }
    
    fileprivate func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.collection, animated: true)
        hud?.labelText = "加载中..."
    }
    
    fileprivate func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDs(for: self.collection, animated: true)
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentImageUrlStr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "girlCell", for: indexPath) as! GGirlCollectionViewCell
        cell.girlsImageView.contentMode = .scaleAspectFit
        cell.girlsImageView.kf_setImageWithURL(URL(string: parentImageUrlStr.object(at: indexPath.row) as! String)!)
    
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    //设置四周边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0.0, 0)
    }
    
    //左右间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    //    上下间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    

}
