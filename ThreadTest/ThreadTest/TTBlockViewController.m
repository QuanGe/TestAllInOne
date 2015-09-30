//
//  TTBlockUIViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/29.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTBlockViewController.h"
#import "TTBlockObject.h"
@interface TTBlockViewController ()

@property (nonatomic,readwrite,assign) void(^blockProperty)(NSInteger one,NSInteger two);
@property (nonatomic,readwrite,strong) TTBlockObject *blockObject;

- (void)testBlock:(void(^)(NSInteger one,NSInteger two))args;
@end

@implementation TTBlockViewController

- (void)dealloc
{
    
    NSLog(@"这里调用就会被释放");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Block相关";
    
    
    __block NSInteger someVar = 100;
    void(^anyBlock)(int);
    anyBlock = ^(int i)
    {
        someVar++;
        NSLog(@"block传参数%@",@(i+someVar));
    };
    anyBlock(10);
    
    void(^anyNoArg)()=^{
        NSLog(@"无参block");
        
    };
    anyNoArg();
    
    [self testBlock:^(NSInteger one, NSInteger two) {
        NSLog(@"函数回调%@",@(one+two+self.view.tag++));
    }];
    
    __weak TTBlockViewController * weakself = self;
    self.blockProperty = ^(NSInteger one,NSInteger two)
    {
        NSLog(@"函数回调%@,当前view的tag是%@",@(one+two+weakself.view.tag++),@(weakself.view.tag));
    };
    
    self.blockObject = [[TTBlockObject alloc] init];
    self.blockObject.logBlock = ^{
        weakself.view.tag++;
        NSLog(@"当前view的tag是：%@",@(weakself.view.tag));
        
    };
    [self.blockObject doSomething];
    [self.blockObject fetchSometheingFromUrlSting:@"http://www.csdn.net" success:^(NSString *result) {
        NSLog(@"%@",[result substringToIndex:100]);
        self.view.tag++;
    }];
    
    self.blockProperty(20,30);
}

- (void)testBlock:(void(^)(NSInteger one,NSInteger two))args
{
    
    args(10,11);
}
@end
