//
//  PMHomeBaseViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMHomeBaseViewController.h"

@implementation PMHomeBaseViewController
- (void)loadView
{
    [super loadView];
    UIImageView * titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100 , 31)];
    {
        [titleView setImage:[UIImage imageNamed:@"logo_s"]];
        [self.navigationItem setTitleView:titleView];
    }
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65 , 25)];
    {
        leftBtn.layer.backgroundColor = mRGBColor(235 , 235, 235).CGColor;
        leftBtn.layer.cornerRadius = 2;
        [leftBtn setTitle:@"恢复购买" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        UIBarButtonItem *leftView = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftView];
    }
}
@end
