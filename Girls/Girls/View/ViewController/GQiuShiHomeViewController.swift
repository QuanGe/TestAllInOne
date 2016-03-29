//
//  GQiuShiHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit

class GQiuShiHomeViewController: UIViewController {
    var viewModel :GQiuBaiViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = GQiuBaiViewModel()
        viewModel?.fetchQiuBaiData(false).subscribeNext({ (result) -> Void in
            NSLog(" 糗百能获取结果")
            }, error: { (error) -> Void in
             NSLog(" 糗百获取失败")
        })
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
}
