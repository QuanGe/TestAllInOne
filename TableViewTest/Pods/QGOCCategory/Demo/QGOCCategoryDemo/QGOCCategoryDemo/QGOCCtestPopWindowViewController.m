//
//  QGOCCtestPopWindowViewController.m
//  QGOCCategoryDemo
//
//  Created by 张如泉 on 15/10/12.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "QGOCCTestPopWindowViewController.h"
#import "QGOCCategory.h"
@implementation QGOCCTestPopWindowViewController

- (void)loadView
{
    [super loadView];
    [self qgocc_buildPopBoxView];
    [self qgocc_updateTitle:@"测试弹窗哦"];
    UITextField * input = [[UITextField alloc] init];
    {
        input.layer.borderColor = [UIColor lightGrayColor].CGColor;
        input.layer.borderWidth = 0.5;
        input.placeholder = @"输入二十个字";
        [input qgocc_setLimitTextLength:20];
        [self.qgocc_popBoxView addSubview:input];
        [input qgocc_configConstraintsWithParentView:self.qgocc_popBoxView rect:CGRectMake(10, 100, 200, 50) marginRightAndBottom:CGPointZero];
    }
    
}
@end
