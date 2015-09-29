//
//  TTRealObjectUIViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/28.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTRealObjectUIViewController.h"
#import "TTSubOperation.h"
#define kThreadMaxNum 1000
@implementation TTRealObjectUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"NSOperation和GCD的本质";
    
    /*经过测试 */
   
    /*
    //operationQueue是operation的线程队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //第一个子线程
    NSOperation *firstOperation = nil;
    //子线程类型0:blockOperation 1:invocationOperation 2:subOperation
    NSUInteger operationType = 0;
    for(NSInteger  i = 0;i<kThreadMaxNum;i++)
    {
        NSOperation *operation = nil;
        //经验证NSBlockOperation和NSInvocationOperation并没有什么区别
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"blockOperation产生子线程%@",@(i).stringValue);
        }];
       
        
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationRun:) object:@(i)];
        
        TTSubOperation *subOperation = [[TTSubOperation alloc] init];
        subOperation.operationID = i;
        switch (operationType) {
            case 0:
                operation = blockOperation;
                break;
            case 1:
                operation = invocationOperation;
                break;
            case 2:
                operation = subOperation;
                break;
            default:
                break;
        }
       
        
        //如果调用start 就相当于同步，会线程阻塞
        //[operation start];
        
        //设置的数量并不是可以无限大，如果超出iphone设备的性能，则基本等于没有设置，或相当于设置了NSOperationQueueDefaultMaxConcurrentOperationCount，代码中设为3有效，但是如果设为kThreadMaxNum则无效 模拟器最大并发数约为64左右
        operationQueue.maxConcurrentOperationCount = kThreadMaxNum;
        
        //addDependency 添加依赖关系，被依赖的要先执行完成后才执行依赖者
        if(i == 0)
            firstOperation = operation;
        else
            [operation addDependency:firstOperation];
  
        [operationQueue addOperation:operation];
    }
    
    */
    
    
    for (int i =0; i<kThreadMaxNum; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun:) object:nil];
        thread.name = [@"子线程:" stringByAppendingString:@(i).stringValue];
        [thread start];
    }
    
    
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
    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (int i =0; i<kThreadMaxNum; i++) {
        
        dispatch_group_async(group,queue, ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
    });
    */
    
    
    
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

- (void)operationRun:(NSNumber *)num
{
    [NSThread sleepForTimeInterval:10];
    NSLog(@"NSInvocationOperation产生子线程%@",num.stringValue);
    
}
@end
