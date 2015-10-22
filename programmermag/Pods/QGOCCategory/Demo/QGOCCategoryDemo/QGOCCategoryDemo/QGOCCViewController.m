//
//  QGOCCViewController.m
//  QGOCCategoryDemo
//
//  Created by 张如泉 on 15/10/3.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "QGOCCViewController.h"
#import "QGOCCategory.h"
#import "QGOCCTestTextViewViewController.h"
#import "QGOCCTestPopWindowViewController.h"
@interface QGOCCViewController ()

@end

@implementation QGOCCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"设备空余容量%@ 当前软件版本号：%@ 当前使用的设备是:%@",[UIDevice qgocc_freeDiskSpaceBytes],[UIDevice qgocc_appVersion],[UIDevice qgocc_deviceVersion] );
    UIButton * go = [[UIButton alloc] init];
    {
        go.tag = 2;
        [self.view addSubview:go];
        go.layer.backgroundColor = [UIColor blueColor].CGColor;
        [go setTitle:@"去textview" forState:UIControlStateNormal];
        [go addTarget:self action:@selector(gotoTextView:) forControlEvents:UIControlEventTouchUpInside];
        [go qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(100, 200, 200, 100) marginRightAndBottom:CGPointZero];
    }
    
    UIButton * testPop = [[UIButton alloc] init];
    {
        testPop.tag = 3;
        [self.view addSubview:testPop];
        testPop.layer.backgroundColor = [UIColor blueColor].CGColor;
        [testPop setTitle:@"去弹窗" forState:UIControlStateNormal];
        [testPop addTarget:self action:@selector(gotoTextView:) forControlEvents:UIControlEventTouchUpInside];
        [testPop qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(100, 400, 200, 100) marginRightAndBottom:CGPointZero];
    }
    
    UIImageView * imageView = [[UIImageView alloc] init];
    {
        [imageView setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, 17, 17, 17)]];
        [self.view addSubview:imageView];
        [imageView qgocc_configConstraintsWithParentView:self.view rect:CGRectMake(100, 100, 34, 34) marginRightAndBottom:CGPointZero];
    }
    
}

- (void)gotoTextView:(UIButton *)sender
{
    if(sender.tag == 2)
    {
        QGOCCTestTextViewViewController * tt = [[QGOCCTestTextViewViewController alloc] init];
        [self.navigationController pushViewController:tt animated:YES];
    }
    else
    {
        QGOCCTestPopWindowViewController * tt = [[QGOCCTestPopWindowViewController alloc] init];
        [tt qgocc_presentedByPresentingVC:self];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
