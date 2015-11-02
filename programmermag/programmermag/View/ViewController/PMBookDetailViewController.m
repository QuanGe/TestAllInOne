//
//  PMBookDetailViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookDetailViewController.h"
#import "PMBookDetailViewModel.h"

@interface PMBookDetailViewController()
@property (nonatomic,readwrite,strong) PMBookDetailViewModel * viewModel;
@end

@implementation PMBookDetailViewController

- (void)loadView
{
    [super loadView];
    [RACObserve(self, bookLocalUrl) subscribeNext:^(id x) {
        
       if(self.viewModel == nil)
           self.viewModel = [[PMBookDetailViewModel alloc] initWithBookLocalUrl:x];
           
        }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
@end
