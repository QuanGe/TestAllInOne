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
import Kingfisher
class GAdvDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var advsCollectionView: UICollectionView!
    @IBOutlet weak var advsPageControl: UIPageControl!
    var photos = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        advsCollectionView.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true;
        self.backBtn.layer.cornerRadius = 20
        self.backBtn.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        self.backBtn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        self.backBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            self.navigationController?.popViewControllerAnimated(true)
            
            return RACSignal.empty()
        })
        MobClick.event("splashAdvDetail")
        self.advsPageControl.numberOfPages = 1;
        self.advsPageControl.currentPage = 0;
        self.showLoadingHUD()
        let imageClick = UserDefaults.standard.object(forKey: "appSplashClick") as? String
        
        
        
        let request = NSMutableURLRequest(url: URL(string:imageClick!)!)
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
                dispatch_async(dispatch_get_main_queue()) {
                   self.advsCollectionView.reloadData()
                   self.advsPageControl.numberOfPages = self.photos.count
                   self.advsPageControl.currentPage = 0
                    
                }
                
                NSLog("%@",self.photos )
                
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.hideLoadingHUD()
        }
        
         }, error: {
            (error) -> Void in
       
            DispatchQueue.main.async {
                self.hideLoadingHUD()
            }
       })
    
    }

    fileprivate func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = "加载中..."
    }
    
    fileprivate func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }

    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advCell", for: indexPath)
        let advImageView = cell.viewWithTag(11) as? UIImageView
        advsCollectionView.contentMode = .scaleAspectFill
        advImageView?.kf_setImageWithURL(URL(string:self.photos[indexPath.row])!)
        self.advsPageControl.currentPage = indexPath.row
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
