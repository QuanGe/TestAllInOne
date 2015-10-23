//
//  PMAPIManager.h
//  programmermag
//
//  Created by 张如泉 on 15/10/20.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PMAPIReturnType)
{
    PMAPIManagerReturnTypeDic,
    PMAPIManagerReturnTypeArray,
    PMAPIManagerReturnTypeStr,
    PMAPIManagerReturnTypeValue,
    PMAPIManagerReturnTypePlain,
    PMAPIManagerReturnTypeM3u8,
    PMAPIManagerReturnTypeXML,
    PMAPIManagerReturnTypeData
    
};

@interface PMAPIManager : AFHTTPRequestOperationManager

+ (instancetype)getInstance;

/**
 获取杂志列表
 */
- (RACSignal *)fetchBookList;


@end
