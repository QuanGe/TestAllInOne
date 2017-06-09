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
        self.edgesForExtendedLayout = UIRectEdge()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib(nibName: "GQiuBaiTableViewCell", bundle: nil), forCellReuseIdentifier: "GQiuBaiTableViewCell")
        tableView.separatorStyle = .none
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
        
        tableView.pullToRefreshView.setTitle("下拉更新", for: .stopped)
        tableView.pullToRefreshView.setTitle("释放更新", for: .triggered)
        tableView.pullToRefreshView.setTitle("卖力加载中", for: .loading)
        tableView.pullType = .visibleLogo
        tableView.triggerPullToRefresh()
        self.title = "糗事百科"
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let content = viewModel?.contentOfRow(indexPath.row)
        let textStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.lineSpacing = 12
        let height: CGFloat = content!.boundingRect(with: CGSize(width: UIScreen.main.bounds.width-16, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSParagraphStyleAttributeName:textStyle], context: nil).size.height
      
        let cellheight: CGFloat = height + 8 + 40 + 5 + (viewModel?.imageHeightOfRow(indexPath.row))!+2+7+10
        return cellheight;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (viewModel?.numOfItems())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GQiuBaiTableViewCell") as! GQiuBaiTableViewCell
        let textStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.lineSpacing = 12
        cell.contentLabel.attributedText = NSAttributedString(string: (viewModel?.contentOfRow(indexPath.row))!, attributes:  [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSParagraphStyleAttributeName:textStyle])
        
        if viewModel?.typeOfRow(indexPath.row) != "word"
        {
           cell.contentImageBtn.kf_setImageWithURL(URL(string:(viewModel?.imageUrlOfRow(indexPath.row))!)!,placeholderImage: UIImage.qgocc_image(with: UIColor.lightGray, size: CGSize(width: UIScreen.main.bounds.width - 16.0, height: (viewModel?.imageHeightOfRow(indexPath.row))!)))
        }
        else
        {
            cell.contentImageBtn.image = nil
        }
        cell.userIconImageView.layer.cornerRadius = 20
        cell.userIconImageView.clipsToBounds = true
        if viewModel?.userIcon(indexPath.row) != ""
        {
            cell.userIconImageView.kf_setImageWithURL(URL(string:(viewModel?.userIcon(indexPath.row))!)!,placeholderImage: UIImage(named: "icon_main"))
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
