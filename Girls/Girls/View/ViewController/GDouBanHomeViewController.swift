//
//  GDouBanHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit

class GDouBanHomeViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    var viewModel :GGirlsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel = GGirlsViewModel()
        viewModel?.fetchGirls(false).subscribeNext({ (result) -> Void in
            NSLog(" 豆瓣美女能获取结果")
            self.collection.reloadData()
            }, error: { (error) -> Void in
                NSLog(" 豆瓣美女能获取结果")
        })
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
        let advImageView = cell.viewWithTag(11) as? UIImageView
        advImageView!.contentMode = .ScaleAspectFill
        advImageView?.kf_setImageWithURL(NSURL(string:(viewModel?.imageUrlOfRow(indexPath.row))!)!)
//        advImageView?.kf_setImageWithURL(NSURL(string:self.photos[indexPath.row])!)
//        self.advsPageControl.currentPage = indexPath.row
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout method
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        return CGSizeMake(UIScreen.mainScreen().bounds.width/2-21, (UIScreen.mainScreen().bounds.width/2-21)*(UIScreen.mainScreen().bounds.height/UIScreen.mainScreen().bounds.width))
        
    }
    
    //设置四周边距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(7, 7, 0, 7)
    }
    
    //左右间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(7)
    }
    
    //    上下间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(7)
    }

}
