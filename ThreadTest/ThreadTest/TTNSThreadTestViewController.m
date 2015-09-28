//
//  TTNSThreadTestViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/27.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTNSThreadTestViewController.h"

#define kTicketsNum 3

@interface TTNSThreadTestViewController ()
@property (nonatomic,readwrite,strong) NSThread* ticketsThreadone;
@property (nonatomic,readwrite,strong) NSThread* ticketsThreadtwo;
@property (nonatomic,readwrite,assign) NSInteger tickets;
@property (nonatomic,readwrite,assign) NSInteger count;
@property (nonatomic,readwrite,strong) NSCondition* ticketsCondition;
@property (nonatomic,readwrite,strong) NSLock *theLock;
@property (nonatomic,readwrite,assign) TTThreadLockType lockType;
@end

@implementation TTNSThreadTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.title = @"NSThread加锁";
    
    self.tickets = kTicketsNum;
    
    self.theLock = [[NSLock alloc] init];
    self.ticketsCondition = [[NSCondition alloc] init];
    
    self.ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.ticketsThreadone setName:@"Thread-1"];
    [self.ticketsThreadone start];
    
    
    self.ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.ticketsThreadtwo setName:@"Thread-2"];
    [self.ticketsThreadtwo start];
    //这里更改加锁的类型，如果为TTThreadLockTypeNone则数据会发生错误
    self.lockType = TTThreadLockTypeNone;
}


- (void)run{
    while (TRUE) {
        
        if(self.lockType == TTThreadLockTypeNone)
        {
            //不加锁
            if(self.tickets >= 0){
                [NSThread sleepForTimeInterval:0.09];
                self.count = kTicketsNum - self.tickets;
                NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                self.tickets--;
            }else{
                break;
            }

        }
        else if(self.lockType == TTThreadLockTypeNSLock)
        {
            // NSLock加锁
            [self.theLock lock];
            if(self.tickets >= 0){
                [NSThread sleepForTimeInterval:0.09];
                self.count = kTicketsNum - self.tickets;
                NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                self.tickets--;
            }else{
                break;
            }
            [self.theLock unlock];
        }
        else if(self.lockType == TTThreadLockTypeNSCondition)
        {
            //NSCondition加锁
            [self.ticketsCondition lock];
            if(self.tickets >= 0){
                [NSThread sleepForTimeInterval:0.09];
                self.count = kTicketsNum - self.tickets;
                NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                self.tickets--;
            }else{
                break;
            }
            [self.ticketsCondition unlock];
        }
        else if(TTThreadLockTypeNSLock)
        {
            //@synchronized加锁
            @synchronized(self)
            {
                if(self.tickets >= 0){
                    [NSThread sleepForTimeInterval:0.09];
                    self.count = kTicketsNum - self.tickets;
                    NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                    self.tickets--;
                }else{
                    break;
                }
            }

        }
    }
}

@end
