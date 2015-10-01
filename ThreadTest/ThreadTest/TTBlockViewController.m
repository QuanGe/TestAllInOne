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
    
    //栈内变量如果在block中只是使用可以不加__block 但是如果修改就必须加上__block
    __block NSInteger someVar = 100;
    //带参数的block声明
    void(^anyBlock)(int);
    //带参数的block赋值
    anyBlock = ^(int i)
    {
        //这里修改了栈内变量
        someVar++;
        NSLog(@"block传参数%@",@(i+someVar));
    };
    //调用block 和函数指针一样哦
    anyBlock(10);
    
    //无参数block的声明和赋值
    void(^anyNoArg)()=^{
        NSLog(@"无参block");
    };
    //调用block
    anyNoArg();
    
    
    
    __weak __typeof(self) weakself = self;
    self.blockProperty = ^(NSInteger one,NSInteger two)
    {
        __strong __typeof(weakself) strongself = weakself;
        NSLog(@"函数回调%@,当前view的tag是%@",@(one+two+weakself.view.tag++),@(strongself.view.tag));
    };
    
    self.blockObject = [[TTBlockObject alloc] init];
    self.blockObject.logBlock = ^{
        __strong __typeof(weakself) strongself = weakself;
        strongself.view.tag++;
        NSLog(@"当前view的tag是：%@",@(strongself.view.tag));
        
    };
    [self.blockObject doSomething];
    [self.blockObject fetchSometheingFromUrlSting:@"http://www.csdn.net" success:^(NSString *result) {
        NSLog(@"%@",[result substringToIndex:100]);
        self.view.tag++;
    }];
    
    
    //带block参数的函数使用时
    [self testBlock:^(NSInteger one, NSInteger two) {
        
        NSLog(@"函数回调%@",@(one+two+self.view.tag++));
    }];
    
    self.blockProperty(20,30);
}

- (void)testBlock:(void(^)(NSInteger one,NSInteger two))args
{
    [self.blockObject doSomething];
    args(10,11);
}
@end
