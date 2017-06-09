//
//  GDouBanSubViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/4/6.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit

class GDouBanSubViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var collection: UICollectionView!
    var viewModel :GGirlsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        collection.backgroundColor = UIColor.white
        
        //automaticallyAdjustsScrollViewInsets = false
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
        
        collection.pullToRefreshView.setTitle("下拉更新", for: .stopped)
        collection.pullToRefreshView.setTitle("释放更新", for: .triggered)
        collection.pullToRefreshView.setTitle("卖力加载中", for: .loading)
        collection.pullType = .visibleLogo
        collection.triggerPullToRefresh()
    }
    
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel == nil ? 0 :(viewModel?.numOfItems())!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "girlCell", for: indexPath)
        let advImageView = cell.viewWithTag(11) as! UIImageView
        advImageView.contentMode = .scaleAspectFill
        advImageView.kf_setImageWithURL(URL(string:(viewModel?.imageUrlOfRow(indexPath.row))!)!,placeholderImage: UIImage.qgocc_image(with: UIColor.lightGray, size: CGSize(width: 1, height: 1)))
        advImageView.layer.cornerRadius = 5.0
        advImageView.layer.masksToBounds = true
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: (UIScreen.main.bounds.width-30)/2, height: ((UIScreen.main.bounds.width-30)/2-30)*(UIScreen.main.bounds.height/UIScreen.main.bounds.width))
        
    }
    
   
    //左右间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    //    上下间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let main = UIStoryboard(name: "Main", bundle: nil);
        let modal=main.instantiateViewController(withIdentifier: "GDoubanDetailViewController") as! GDoubanDetailViewController
        for i in 0 ..< viewModel!.numOfItems()
        {
            modal.parentImageUrlStr.add(viewModel!.imageUrlOfRow(i))
        }
        modal.curIndex = indexPath
        self.navigationController?.pushViewController(modal, animated: true);
    }

}
