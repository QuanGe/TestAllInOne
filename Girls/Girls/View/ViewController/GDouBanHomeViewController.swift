//
//  GDouBanHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import SVPullToRefresh
class GDouBanHomeViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    var viewModel :GGirlsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        collection.backgroundColor = UIColor.whiteColor()
        viewModel = GGirlsViewModel()
        
        viewModel?.fetchGirls(false).subscribeNext({ (result) -> Void in
            NSLog(" 豆瓣美女能获取结果")
            self.collection.reloadData()
            }, error: { (error) -> Void in
                NSLog(" 豆瓣美女能获取结果")
        })
        
        collection.addPullToRefreshWithActionHandler { () -> Void in
            
            self.viewModel?.fetchGirls(false).subscribeNext({ (result) -> Void in
                
                self.collection.reloadData()
                self.collection.pullToRefreshView.stopAnimating()
                }, error: { (error) -> Void in
                    self.collection.pullToRefreshView.stopAnimating()
                    self.collection.showNoNataViewWithMessage(NSLocalizedString(error.userInfo[NSLocalizedDescriptionKey] as! String, comment: ""), imageName: nil)
            })
            
        }
        
        collection.addInfiniteScrollingWithActionHandler { () -> Void in
            self.viewModel?.fetchGirls(true).subscribeNext({ (result) -> Void in
                
                self.collection.reloadData()
                self.collection.infiniteScrollingView.stopAnimating()
                }, error: { (error) -> Void in
                    self.collection.infiniteScrollingView.stopAnimating()
                    self.collection.showNoNataViewWithMessage(NSLocalizedString(error.userInfo[NSLocalizedDescriptionKey] as! String, comment: ""), imageName: nil)
            })
        }
        
        collection.pullToRefreshView.setTitle("下拉更新", forState: .Stopped)
        collection.pullToRefreshView.setTitle("释放更新", forState: .Triggered)
        collection.pullToRefreshView.setTitle("卖力加载中", forState: .Loading)
        collection.pullType = .VisibleLogo
        collection.triggerPullToRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    // MARK: - Collection view data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.numOfItems())!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("girlCell", forIndexPath: indexPath)
        let advImageView = cell.viewWithTag(11) as! UIImageView
        advImageView.contentMode = .ScaleAspectFill
        advImageView.kf_setImageWithURL(NSURL(string:(viewModel?.imageUrlOfRow(indexPath.row))!)!)
        advImageView.layer.cornerRadius = 5.0
        advImageView.layer.masksToBounds = true
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout method
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        return CGSizeMake((UIScreen.mainScreen().bounds.width-30)/2, ((UIScreen.mainScreen().bounds.width-30)/2-30)*(UIScreen.mainScreen().bounds.height/UIScreen.mainScreen().bounds.width))
        
    }
    
    //设置四周边距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10)
    }
    
    //左右间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    //    上下间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(10)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let main = UIStoryboard(name: "Main", bundle: nil);
        let modal=main.instantiateViewControllerWithIdentifier("GDoubanDetailViewController") as! GDoubanDetailViewController
        for i in 0 ..< viewModel!.numOfItems()
        {
            modal.parentImageUrlStr.addObject(viewModel!.imageUrlOfRow(i))
        }
        modal.curIndex = indexPath
        self.navigationController?.pushViewController(modal, animated: false);
    }

    

}
