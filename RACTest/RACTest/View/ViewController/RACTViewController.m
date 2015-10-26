//
//  RACTViewController.m
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "RACTViewController.h"
#import "UIView+WillChange.h"

@interface RACTViewController ()

@end

@implementation RACTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"category返回的view的宽度到底是多少%@",@([self.view width]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
