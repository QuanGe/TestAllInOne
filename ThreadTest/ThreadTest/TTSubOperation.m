//
//  TTSubOperation.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/29.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTSubOperation.h"

@interface TTSubOperation ()
@property (nonatomic ,readwrite,assign) BOOL hasCompleted;
@end

@implementation TTSubOperation


- (void)main
{
    self.hasCompleted = NO;
    [NSThread sleepForTimeInterval:10];
    NSLog(@"TTSubOperation创建的子线程%@",@(self.operationID).stringValue);

}
@end
