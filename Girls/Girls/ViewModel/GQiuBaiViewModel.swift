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
        super.init()
        self.qiubaiModels = []
    }
    
    func fetchQiuBaiData(_ more: Bool)->RACSignal{
        
        let page = !more ? 1 : ((self.qiubaiModels!.count - self.qiubaiModels!.count%40 )/40+(self.qiubaiModels!.count%40 == 0 ? 1 : 2))
        //let gifDuration = more  ? 1 : 0
        
        return GAPIManager.sharedInstance.fetchQiuBaiHot(page).map({ (result) -> AnyObject! in
            if !more {
                self.qiubaiModels?.removeAllObjects()
                
            }
            self.qiubaiModels?.addObjectsFromArray(result as! [AnyObject])
            return result
        })
        
    }
    
    func numOfItems()->Int{
        return (qiubaiModels?.count)!
    }
    
    func contentOfRow(_ row:Int)->String{
        let model = qiubaiModels![row] as! GQiuBaiModel
        return model.content!
    }
    
    func typeOfRow(_ row:Int)->String
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        return model.format!
    }
    
    func imageUrlOfRow(_ row:Int)->String
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        if model.format == "image"
        {
            let imageId = model.modelId!.stringValue as NSString
            let prefiximageId = imageId.substring(to: imageId.length - 4)
            //imagURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/small/\(model.image)"
           
            let image = model.image! as NSString
            let url = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/medium/\(image)"

            return url
        } else if model.format == "video"
        {
            return model.pic_url!
        }
        
        
        return ""
    }
    
    func imageHeightOfRow(_ row:Int)->CGFloat
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        if model.format == "image"
        {
            let size = model.imageSize! as NSDictionary
            let sizeInfo = size["m"] as! NSArray
            let hw = (sizeInfo.object(at: 1) as AnyObject).floatValue/(sizeInfo.object(at: 0) as AnyObject).floatValue
            
            let h = (UIScreen.main.bounds.width - 16.0) * CGFloat(hw)
            return h
        } else if model.format == "video"
        {
            let h = UIScreen.main.bounds.width - 16.0
            return h
        }

        return 0
    }
    
    func userIcon(_ row:Int)->String
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        if model.user == nil
        {
            return ""
        }
        
        let userInfor = model.user! as NSDictionary
        let icon  = userInfor["icon"] as! NSString
    
        let idNumber = userInfor["id"] as? NSNumber
            let userId = idNumber!.stringValue as NSString
            let prefixUserId = userId.substring(to: userId.length - 4)
            
            let userImageURL = "http://pic.qiushibaike.com/system/avtnew/\(prefixUserId)/\(userId)/medium/\(icon)"
            
            return userImageURL
            
        

        
    }
    
    func userNickName(_ row:Int)->String
    {
        let model = qiubaiModels![row] as! GQiuBaiModel
        let userInfor = model.user! as NSDictionary
        
        return userInfor["login"] as! String
    }
    
    
}
