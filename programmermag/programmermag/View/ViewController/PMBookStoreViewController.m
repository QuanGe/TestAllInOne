//
//  PMBookStoreViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookStoreViewController.h"

@implementation PMBookStoreViewController

- (void)loadView
{
    [super loadView];
    UIView * customBarButtonBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    {
        UIButton * changeUIBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        
        [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, 0, 17, 17)] forState:UIControlStateNormal];
        [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, 16, 17, 17)] forState:UIControlStateHighlighted];
        changeUIBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            changeUIBtn.tag = changeUIBtn.tag == 0?1:0;
            [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, changeUIBtn.tag == 0?0:32, 17, 17)] forState:UIControlStateNormal];
            [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, changeUIBtn.tag == 0?17:51, 17, 17)] forState:UIControlStateHighlighted];
            return [RACSignal empty];
        }];
        [customBarButtonBox addSubview:changeUIBtn];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonBox];
        [self.navigationItem setRightBarButtonItem:rightBtn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
@end
