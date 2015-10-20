//
//  PMDBManager.h
//  programmermag
//
//  Created by 张如泉 on 15/10/19.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PMDBManager : NSObject
+ (instancetype)getInstance;

@property (strong, nonatomic) NSString *databasePath;

/**
 获取所有杂志目录
 
 */
- (NSMutableArray*)fetchAllBooks;

/**
 获取我的杂志目录
 
 */
- (NSMutableArray*)fetchMylBooks;

@end
