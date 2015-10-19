//
//  UIViewController+PopWindow.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/11.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PopWindow)
@property (nonatomic) UIView *qgocc_popBoxView;
@property (nonatomic) UIViewController*qgocc_presentingVC;

/**
 *  创建显示层,第一步要做的就是这个，可以写在[super loadView]的下面
 *  return  无
 */
- (void)qgocc_buildPopBoxView;

/**
 *  设置弹框层的标题
 *  @param  title:标题
 *  return  无
 */
- (void)qgocc_updateTitle:(NSString*)title;

/**
 *  在最上面标题栏的view添加子控件
 *  @param  sub:子控件
 *  return  无
 */
- (void)qgocc_addTopSubView:(UIView*)sub;

/**
 *  在当前页面弹出此弹框
 *  @param  presentingVC:当前页面
 *  return  无
 */
- (void)qgocc_presentedByPresentingVC:(UIViewController*)presentingVC;

/**
 *  当要显示的时候需要有个动画可以在viewWillAppear中做此动作
 *  return  无
 */
- (void)qgocc_popupAnimationWithSpring;

/**
 *  更新背景颜色 和大小 在viewWillLayoutSubviews中调用
 *  return  无
 */
- (void)qgocc_viewWillLayout;

/**
 *  返回
 *  @param  flag:是否有动画
 *  @param  completion:是否有完成block
 *  return  无
 */
-(void)qgocc_dismissViewController:(BOOL)flag completion:(void (^)(void))completion;
@end
