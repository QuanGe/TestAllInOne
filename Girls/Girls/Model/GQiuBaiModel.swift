//
//  GQiuBaiModel.swift
//  Girls
//
//  Created by 张如泉 on 16/3/29.
//  Copyright © 2016年 quange. All rights reserved.
//

import Mantle

class GQiuBaiModel: MTLModel,MTLJSONSerializing {
    var format :String?
    var image :String?
    var content :String?
    var user :NSDictionary?
    var pic_url :String?
    var high_url :String?
    var imageSize :NSDictionary?
    var modelId : NSNumber?
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        return ["format":"format",
        "image":"image",
            "content":"content",
            "user":"user",
            "pic_url":"pic_url",
            "high_url":"high_url",
            "modelId":"id",
            "imageSize":"image_size"
        ]
    }
}
