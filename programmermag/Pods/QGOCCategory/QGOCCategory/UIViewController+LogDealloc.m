//
//  UIViewController+LogDealloc.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/3.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIViewController+LogDealloc.h"
#import <objc/runtime.h>

@implementation UIViewController (LogDealloc)

+(void)load {
    SEL deallocSelector = sel_registerName("dealloc");
    Method dea = class_getInstanceMethod(self, deallocSelector);
    Method qgoc_logDealloc = class_getInstanceMethod(self, @selector(qgocc_logDealloc));
    method_exchangeImplementations(dea, qgoc_logDealloc);
}

-(void)qgocc_logDealloc
{
    NSLog(@"%@ 类型的viewcontroller进行了释放",NSStringFromClass(self.class));
    [self qgocc_logDealloc];
}
@end
