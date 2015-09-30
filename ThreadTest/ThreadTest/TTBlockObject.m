//
//  TTBlockObject.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/30.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTBlockObject.h"

@interface TTBlockObject ()

@end

@implementation TTBlockObject

- (void)doSomething
{
    self.logBlock();
}

- (void)fetchSometheingFromUrlSting:(NSString *)urlString success:(void (^)(NSString * result) )block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString * string = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
        block(string);
    });
}
@end
