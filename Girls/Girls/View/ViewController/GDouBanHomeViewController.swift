//
//  GDouBanHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import SVPullToRefresh
import QGCollectionMenu
class GDouBanHomeViewController: UIViewController,QGCollectionMenuDataSource,QGCollectionMenuDelegate {

    let titleArray : NSArray = [ "有颜值","美腿控","大胸妹", "小翘臀", "黑丝袜",  "大杂烩"]
    let titleType : NSArray = ["4","3","2","6","7","5"]
    var viewModels : NSMutableArray = []
    @IBOutlet weak var collectionMenu: QGCollectionMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.collectionMenu.dataSource = self;
        self.collectionMenu.delegate = self;
        self.collectionMenu.reload();
       
        for node in titleType{
            
            viewModels.addObject(GGirlsViewModel(dataType: node as! String)!)
        }
        self.title = "豆瓣美女"
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionMenu.subVCCollectionContentInsetUpdate()
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.qgocc_tabBarHidden = false;
        //self.navigationController!.navigationBar.translucent  = true;
    }
    
    func menumTitles() -> [AnyObject]!
    {
        return titleArray as [AnyObject]
    }
    //
    func subVCClassStrsForStoryBoard() -> [AnyObject]!
    {
        return ["GDouBanSubViewController", "GDouBanSubViewController", "GDouBanSubViewController", "GDouBanSubViewController", "GDouBanSubViewController", "GDouBanSubViewController"]

    }
    //
    func subVCClassStrsForCode() -> [AnyObject]!
    {
        return []
    }

    func updateSubVCWithIndex(index: Int)
    {
        let subs: [(GDouBanSubViewController)] = self.childViewControllers as! [(GDouBanSubViewController)];
        for vc in subs {
            if(vc.view.tag == index)
            {
                if(vc.viewModel != viewModels[index] as? GGirlsViewModel)
                {
                    vc.viewModel = viewModels[index] as? GGirlsViewModel
                    vc.collection.reloadData()
                }
                
                if vc.viewModel?.numOfItems()==0
                {
                    vc.collection.triggerPullToRefresh()
                }
                break
                
            }
        }
    }
}
