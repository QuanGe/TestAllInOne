//
//  GQiuBaiViewModel.swift
//  Girls
//
//  Created by 张如泉 on 16/3/29.
//  Copyright © 2016年 quange. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa
class GQiuBaiViewModel: RVMViewModel {
    var qiubaiModels :NSMutableArray?
    
    override init() {
        
        self.qiubaiModels = []
    }
    
    func fetchQiuBaiData(more: Bool)->RACSignal{
        
        let page = !more ? 1 : ((self.qiubaiModels!.count - self.qiubaiModels!.count%40 )/40+(self.qiubaiModels!.count%40 == 0 ? 1 : 2))
        //let gifDuration = more  ? 1 : 0
        
        return GAPIManager.sharedInstance.fetchQiuBaiHot(page).map({ (result) -> AnyObject! in
            if more {
                self.qiubaiModels?.removeAllObjects()
                
            }
            self.qiubaiModels?.addObjectsFromArray(result as! [AnyObject])
            return result
        })
        
    }
    
    func numOfItems()->Int{
        return (qiubaiModels?.count)!
    }
    
    func contentOfRow(row:Int)->String{
        let model = qiubaiModels![row] as! GQiuBaiModel
        return model.content!
    }
    
    func typeOfRow(row:Int)->String
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        return model.format!
    }
    
    func imageUrlOfRow(row:Int)->String
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        return model.image!
    }
    
    
}
