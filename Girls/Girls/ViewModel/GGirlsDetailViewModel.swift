//
//  GGirlsDetailViewModel.swift
//  Girls
//
//  Created by 张如泉 on 16/3/30.
//  Copyright © 2016年 quange. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa

class GGirlsDetailViewModel: RVMViewModel {

    var girls :NSMutableArray = []
    var grilsDetailUrls :NSMutableArray = []
    
    func fetchGirlsUrlStr()->RACSignal
    {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            self.girls.removeAllObjects()
            var i :NSTimeInterval = 0.0;
            for url in self.grilsDetailUrls
            {
                i = i + 0.3
                GAPIManager.sharedInstance.fetchGirlsWithUrlstr(url as! String).delay(NSTimeInterval(i))
                    .subscribeNext({ (result) -> Void in
                    self.girls.addObjectsFromArray(result as! [AnyObject])
                    subscriber.sendNext(result)
                        if url as! String  == self.grilsDetailUrls.lastObject as! String
                        {
                        subscriber.sendCompleted()
                        }
                    
                })
            }
            return RACDisposable(block: { () -> Void in
                
            })
        })
    }
    
    func numerOfGirls()->Int
    {
        return girls.count
    }
    
    func imageUrlWithRow(_ row:Int)->String
    {
        return girls[row] as! String
    }
}
