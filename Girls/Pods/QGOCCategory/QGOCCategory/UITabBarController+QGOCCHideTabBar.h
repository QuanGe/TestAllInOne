//
//  UITabBarController+QGOCCHideTabBar.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (QGOCCHideTabBar)

@property (nonatomic, getter=qgocc_isTabBarHidden) BOOL qgocc_tabBarHidden;

- (void)setQgocc_tabBarHidden:(BOOL)hidden;
@end
