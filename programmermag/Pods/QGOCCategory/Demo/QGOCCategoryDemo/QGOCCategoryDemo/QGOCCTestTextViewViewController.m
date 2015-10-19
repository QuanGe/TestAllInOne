//
//  QGOCCTestTextViewViewController.m
//  QGOCCategoryDemo
//
//  Created by 张如泉 on 15/10/8.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "QGOCCTestTextViewViewController.h"
#import "QGOCCategory.h"
@implementation QGOCCTestTextViewViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * back = [[UIButton alloc] init];
    {
        [self.view addSubview:back];
        [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
        [back qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(0, 60, 100, 50) marginRightAndBottom:CGPointZero];
    }
    
    UITextView *text = [[UITextView alloc] init];
    {
        text.backgroundColor= [UIColor lightGrayColor];
        [self.view addSubview:text];
        //[text qgocc_setPlaceHolder:@"输入内容吧在这里,最多5个字"];
        //[text qgocc_setMaxLengthNum:5];
       
        [text qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(100, 160, 200, 200) marginRightAndBottom:CGPointZero];
        
        NSMutableAttributedString *thetext = [[NSMutableAttributedString alloc] initWithString:@"虽然当今设备日益网络化，但它们大多数还是处于独立工作状态。在Gartner预测的设备网中，情况将会改变。不同设备，例如智能手机、可穿戴设备和家庭娱乐设备以及汽车之间彼此间可以互相沟通" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSMutableAttributedString *addtext = [[NSMutableAttributedString alloc] initWithString:@"[查看更多]" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor redColor]}];
        text.attributedText = [thetext qgocc_addStringByWord:addtext viewWidth:190];
    }
}

- (void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
