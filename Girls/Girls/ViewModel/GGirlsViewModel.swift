//
//  GGirlsViewModel.swift
//  Girls
//
//  Created by 张如泉 on 16/3/29.
//  Copyright © 2016年 quange. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa

class GGirlsViewModel: RVMViewModel {
    var girls :NSMutableArray?
    
    override init() {
        
        self.girls = []
    }
    
    func fetchGirls(more: Bool)->RACSignal{
        
        let page = !more ? 1 : ((self.girls!.count - self.girls!.count%20 )/20+(self.girls!.count%20 == 0 ? 1 : 2))
        //let gifDuration = more  ? 1 : 0
        
        return GAPIManager.sharedInstance.fetchGirls(page).map({ (result) -> AnyObject! in
            if !more {
                self.girls?.removeAllObjects()
                
            }
            self.girls?.addObjectsFromArray(result as! [AnyObject])
            return result
        })
        
    }
    
    func numOfItems()->Int{
        return (girls?.count)!
    }
    
  
    func imageDetailUrlOfRow(row:Int)->String
    {
        let model = girls![row] as! GGirlsModel
        return model.imageDetailUrlStr
    }
    
    func imageUrlOfRow(row:Int)->String
    {
        let model = girls![row] as! GGirlsModel
        return model.imageUrlStr
    }

}
