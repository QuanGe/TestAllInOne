//
//  PMMyBookViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMMyBookViewController.h"

@implementation PMMyBookViewController
- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.viewModel fetchMyBookList] subscribeNext:^(id x) {
        [self.dataView reloadData];
    }];
}
@end
