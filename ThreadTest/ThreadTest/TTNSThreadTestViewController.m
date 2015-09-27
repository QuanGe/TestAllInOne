//
//  TTNSThreadTestViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/27.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTNSThreadTestViewController.h"

@interface TTNSThreadTestViewController ()
@property (nonatomic,readwrite,strong) NSThread* ticketsThreadone;
@property (nonatomic,readwrite,strong) NSThread* ticketsThreadtwo;
@property (nonatomic,readwrite,assign) NSInteger tickets;
@property (nonatomic,readwrite,assign) NSInteger count;
@property (nonatomic,readwrite,strong) NSCondition* ticketsCondition;
@property (nonatomic,readwrite,strong) NSLock *theLock;
@end

@implementation TTNSThreadTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.tickets = 3;
    
    self.theLock = [[NSLock alloc] init];
    self.ticketsCondition = [[NSCondition alloc] init];
    
    self.ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.ticketsThreadone setName:@"Thread-1"];
    [self.ticketsThreadone start];
    
    
    self.ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.ticketsThreadtwo setName:@"Thread-2"];
    [self.ticketsThreadtwo start];
    
    self.view.tag = 3;
}


- (void)run{
    while (TRUE) {
        
        if(self.view.tag == 0)
        {
            //不加锁
            if(self.tickets >= 0){
                [NSThread sleepForTimeInterval:0.09];
                self.count = 100 - self.tickets;
                NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                self.tickets--;
            }else{
                break;
            }

        }
        else if(self.view.tag == 1)
        {
            // NSLock加锁
            [self.theLock lock];
            if(self.tickets >= 0){
                [NSThread sleepForTimeInterval:0.09];
                self.count = 100 - self.tickets;
                NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                self.tickets--;
            }else{
                break;
            }
            [self.theLock unlock];
        }
        else if(self.view.tag == 2)
        {
            //NSCondition加锁
            [self.ticketsCondition lock];
            if(self.tickets >= 0){
                [NSThread sleepForTimeInterval:0.09];
                self.count = 100 - self.tickets;
                NSLog(@"当前票数是:%@,售出:%@,线程名:%@",@(self.tickets),@(self.count),[[NSThread currentThread] name]);
                self.tickets--;
            }else{
                break;
            }
            [self.ticketsCondition unlock];
        }
        else if(self.view.tag == 3)
        {
            //@synchronized加锁
            @synchronized(self)
            {
                if(self.tickets >= 0){
                    [NSThread sleepForTimeInterval:0.09];
                    self.count = 100 - self.tickets;
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
