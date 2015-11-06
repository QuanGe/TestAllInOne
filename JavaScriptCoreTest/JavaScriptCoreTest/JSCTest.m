//
//  JSCTest.m
//  JavaScriptCoreTest
//
//  Created by 张如泉 on 15/11/6.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "JSCTest.h"

@implementation JSCTest
- (id)objectAtIndexedSubscript:(NSUInteger)index
{
    return @(110);
}
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    return;
}
@end
