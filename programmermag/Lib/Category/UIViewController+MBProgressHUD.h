//
//  UIViewController+MBProgressHUD.h
//  EducationVideo
//
//  Created by zhangruquan on 15/5/19.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MBProgressHUD)
- (void)showLoadAlertView:(NSString*)title imageName:(NSString*)name  autoHide:(BOOL)hide;
- (void)hideLoadAlertView;
@end
