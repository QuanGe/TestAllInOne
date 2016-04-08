//
//  GQiuShiHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import SVPullToRefresh
import QGOCCategory
class GQiuShiHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var viewModel :GQiuBaiViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .None
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerNib(UINib(nibName: "GQiuBaiTableViewCell", bundle: nil), forCellReuseIdentifier: "GQiuBaiTableViewCell")
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        
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
        tableView.pullType = .VisibleLogo
        tableView.triggerPullToRefresh()
        self.title = "糗事百科"
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let content = viewModel?.contentOfRow(indexPath.row)
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.lineSpacing = 12
        let height: CGFloat = content!.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width-16, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14),NSParagraphStyleAttributeName:textStyle], context: nil).size.height
      
        let cellheight: CGFloat = height + 8 + 40 + 5 + (viewModel?.imageHeightOfRow(indexPath.row))!+2+7+10
        return cellheight;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (viewModel?.numOfItems())!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("GQiuBaiTableViewCell") as! GQiuBaiTableViewCell
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.lineSpacing = 12
        cell.contentLabel.attributedText = NSAttributedString(string: (viewModel?.contentOfRow(indexPath.row))!, attributes:  [NSFontAttributeName: UIFont.systemFontOfSize(14),NSParagraphStyleAttributeName:textStyle])
        
        if viewModel?.typeOfRow(indexPath.row) != "word"
        {
           cell.contentImageBtn.kf_setImageWithURL(NSURL(string:(viewModel?.imageUrlOfRow(indexPath.row))!)!,placeholderImage: UIImage.qgocc_imageWithColor(UIColor.lightGrayColor(), size: CGSizeMake(UIScreen.mainScreen().bounds.width - 16.0, (viewModel?.imageHeightOfRow(indexPath.row))!)))
        }
        else
        {
            cell.contentImageBtn.image = nil
        }
        cell.userIconImageView.layer.cornerRadius = 20
        cell.userIconImageView.clipsToBounds = true
        if viewModel?.userIcon(indexPath.row) != ""
        {
            cell.userIconImageView.kf_setImageWithURL(NSURL(string:(viewModel?.userIcon(indexPath.row))!)!,placeholderImage: UIImage(named: "icon_main"))
            cell.nickNameLabel.text = viewModel?.userNickName(indexPath.row)
        }
        else
        {
            cell.userIconImageView.image = UIImage(named: "icon_main")
            cell.nickNameLabel.text = "匿名"
        }
        
        return cell
    }
    
    
}
