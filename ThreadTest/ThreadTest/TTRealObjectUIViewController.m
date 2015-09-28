//
//  TTRealObjectUIViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/28.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTRealObjectUIViewController.h"
#define kThreadMaxNum 1000
@implementation TTRealObjectUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"NSOperation和GCD的本质";
    
    /*经过测试 */
   
    /*
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    for(int  i = 0;i<kThreadMaxNum;i++)
    {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"blockOperation产生子线程%@",@(i).stringValue);
        }];
        BOOL isConcurrent = [blockOperation isConcurrent];
        blockOperation.name = [@"子线程:" stringByAppendingString:@(i).stringValue];
        operationQueue.maxConcurrentOperationCount = kThreadMaxNum;
        [operationQueue addOperation:blockOperation];
    }
    */
    
    /*
    for (int i =0; i<kThreadMaxNum; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun:) object:nil];
        thread.name = [@"子线程:" stringByAppendingString:@(i).stringValue];
        [thread start];
    }
    */
    
    /*
    for (int i =0; i<kThreadMaxNum; i++) {
        dispatch_queue_t queue = dispatch_queue_create([@"子线程%@" stringByAppendingString:@(i).stringValue].UTF8String, DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
        
     }
    */
    
    
    /*
    for (int i =0; i<kThreadMaxNum; i++) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
        
    }
    */
    
    dispatch_group_t group = dispatch_group_create();
    for (int i =0; i<kThreadMaxNum; i++) {
        
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
        
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"GCD获取到的主线程是：%@",dispatch_get_main_queue());
    });
    NSLog(@"NSThread获取到的主线程是：%@",[NSThread mainThread]);
    */
    
}

- (void)threadRun:(NSThread *)thread
{
    [NSThread sleepForTimeInterval:10];
    NSLog(@"NSThread产生子线程%@",[NSThread currentThread]);
    
}
@end
