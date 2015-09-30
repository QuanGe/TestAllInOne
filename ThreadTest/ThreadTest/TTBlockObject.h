//
//  TTBlockObject.h
//  ThreadTest
//
//  Created by 张如泉 on 15/9/30.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBlockObject : NSObject
@property (nonatomic,readwrite,copy) void (^logBlock)();
- (void)doSomething;
- (void)fetchSometheingFromUrlSting:(NSString *)urlString success:(void (^)(NSString *) )block;
@end
