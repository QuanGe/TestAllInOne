//
//  TTRealObjectUIViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/28.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTRealObjectViewController.h"
#import "TTSubOperation.h"
#define kThreadMaxNum 1000
@implementation TTRealObjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"NSOperation和GCD的本质";
    
    /*经过测试 */
   
    /*
     
    //---------------------------NSOperation测试---------------------------------
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
        
        //addDependency 添加依赖关系，被依赖的要先执行完成后才执行依赖者 可以用此来控制线程执行的顺序
        if(i == 0)
            firstOperation = operation;
        else
            [operation addDependency:firstOperation];
  
        [operationQueue addOperation:operation];
    }
    
    */
    
    /*、
    //---------------------------NSThread测试---------------------------------
    //果然是轻量级的，1000个线程同时创建 同时执行，很快，坏处就是需要自己处理线程同步，有可能会死锁
    for (NSInteger i =0; i<kThreadMaxNum; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun:) object:@(i)];
        thread.stackSize = 10240;
        thread.name = [@"子线程:" stringByAppendingString:@(i).stringValue];
        [thread start];
    }
    */
    
    
    //---------------------------GCD之dispatch_queue_create并行队列测试---------------------------------
    //并行队列 线程数量受设备影响 模拟器最多开启63左右
    dispatch_queue_t concurrentQueue = dispatch_queue_create("并行队列", DISPATCH_QUEUE_CONCURRENT);
    for (int i =0; i<kThreadMaxNum; i++) {
        if(i == 0)
            //dispatch_barrier_async函数只有在dispatch_queue_create创建的子线程中有效 在dispatch_get_global_queue创建的子线程中无效，可以用来控制线程顺序，此函数之前的线程在其之前执行，此函数之后的在其后执行
            dispatch_barrier_async(concurrentQueue, ^{
                [NSThread sleepForTimeInterval:10];
                NSLog(@"GCD产生子线程%@",@(i).stringValue);
            });
        else
            dispatch_async(concurrentQueue, ^{
                [NSThread sleepForTimeInterval:10];
                NSLog(@"GCD产生子线程%@",@(i).stringValue);
            });
        
     }
    
    
    /*
    //---------------------------GCD之dispatch_queue_create串行队列测试---------------------------------
    //串行队列 线程数量受设备影响 模拟器最多开启63左右
    dispatch_queue_t queue = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
    for (int i =0; i<kThreadMaxNum; i++) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
        
    }
    */
    
    /*
    //---------------------------GCD之dispatch_get_global_queue并行队列测试---------------------------------
    //并行队列 线程数量受设备影响 模拟器最多开启63左右
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i =0; i<kThreadMaxNum; i++) {
        if(i == 0)
            //dispatch_barrier_async函数只有在dispatch_queue_create创建的子线程中有效 在dispatch_get_global_queue创建的子线程中无效，可以用来控制线程顺序，此函数之前的线程在其之前执行，此函数之后的在其后执行
            dispatch_barrier_async(queue, ^{
                [NSThread sleepForTimeInterval:10];
                NSLog(@"GCD产生子线程%@",@(i).stringValue);
            });
        else
            dispatch_async(queue, ^{
                [NSThread sleepForTimeInterval:10];
                NSLog(@"GCD产生子线程%@",@(i).stringValue);
            });
        
    }
    */
    
    /*
    //---------------------------GCD之dispatch_apply测试---------------------------------
    //dispatch_apply 是在主线程中操作 会阻塞主线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(kThreadMaxNum, queue, ^(size_t i) {
        //[NSThread sleepForTimeInterval:10];
        NSLog(@"GCD产生子线程%@",@(i).stringValue);
    });
    */
    
    /*
    //---------------------------GCD之dispatch_group_create测试---------------------------------
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

- (void)threadRun:(NSNumber *)num
{
    [NSThread sleepForTimeInterval:10];
    NSLog(@"NSThread产生子线程%@",num.stringValue);
    
}

- (void)operationRun:(NSNumber *)num
{
    [NSThread sleepForTimeInterval:10];
    NSLog(@"NSInvocationOperation产生子线程%@",num.stringValue);
    
}
@end
