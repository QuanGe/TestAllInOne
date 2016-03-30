//
//  GQiuShiHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import SVPullToRefresh
class GQiuShiHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var viewModel :GQiuBaiViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "GQiuBaiTableViewCell", bundle: nil), forCellReuseIdentifier: "GQiuBaiTableViewCell")
        tableView.separatorStyle = .None
        viewModel = GQiuBaiViewModel()
        tableView.addPullToRefreshWithActionHandler { () -> Void in
            
            self.viewModel?.fetchQiuBaiData(false).subscribeNext({ (result) -> Void in
                
                self.tableView.reloadData()
                self.tableView.pullToRefreshView.stopAnimating()
                }, error: { (error) -> Void in
                   self.tableView.pullToRefreshView.stopAnimating()
                    self.tableView.showNoNataViewWithMessage(NSLocalizedString(error.userInfo[NSLocalizedDescriptionKey] as! String, comment: ""), imageName: nil)
            })

        }
        
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.viewModel?.fetchQiuBaiData(true).subscribeNext({ (result) -> Void in
                
                self.tableView.reloadData()
                self.tableView.infiniteScrollingView.stopAnimating()
                }, error: { (error) -> Void in
                    self.tableView.infiniteScrollingView.stopAnimating()
                    self.tableView.showNoNataViewWithMessage(NSLocalizedString(error.userInfo[NSLocalizedDescriptionKey] as! String, comment: ""), imageName: nil)
            })
        }
        
        tableView.pullToRefreshView.setTitle("下拉更新", forState: .Stopped)
        tableView.pullToRefreshView.setTitle("释放更新", forState: .Triggered)
        tableView.pullToRefreshView.setTitle("卖力加载中", forState: .Loading)
        tableView.triggerPullToRefresh()
        
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let content = viewModel?.contentOfRow(indexPath.row)
        
        let height: CGFloat = content!.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width-16, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12)], context: nil).size.height
      
        return height+40+8+20;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (viewModel?.numOfItems())!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("GQiuBaiTableViewCell") as! GQiuBaiTableViewCell
        cell.contentLabel.text = viewModel?.contentOfRow(indexPath.row)
        
        return cell
    }
    
    
}
