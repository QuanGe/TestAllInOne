//
//  TTNSThreadTestViewController.h
//  ThreadTest
//
//  Created by 张如泉 on 15/9/27.
//  Copyright © 2015年 QuanGe. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TTThreadLockType){
    TTThreadLockTypeNone,
    TTThreadLockTypeNSCondition,
    TTThreadLockTypeNSLock,
    TTThreadLockTypeSynchronized
    
};

@interface TTNSThreadTestViewController : UIViewController

@end
