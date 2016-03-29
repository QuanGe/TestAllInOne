//
//  GNavigationController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/25.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit

class GNavigationController: UINavigationController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        resetDelegate()
    }
    
    func resetDelegate(){
        delegate = self
    }
}
