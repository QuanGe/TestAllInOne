//
//  UIAlertView+QGOCCBlock.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^qgocc_UIAlertViewTapBlock) (UIAlertView *alertView, NSInteger buttonIndex);
@interface UIAlertView (QGOCCBlock)

/**
 *  弹框 点击事件以block实现
 *  @param  title:弹框标题
 *  @param  message:弹框内容
 *  @param  style:弹框样式
 *  @param  cancelButtonTitle:取消按钮上的文字
 *  @param  otherButtonTitles:其他按钮上的文字
 *  @param  tapBlock:点击block
 *  return  点击事件以block实现的弹框
 */
+ (instancetype)qgocc_showWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(qgocc_UIAlertViewTapBlock)tapBlock;

/**
 *  弹框 点击事件以block实现
 *  @param  title:弹框标题
 *  @param  message:弹框内容
 *  @param  cancelButtonTitle:取消按钮上的文字
 *  @param  otherButtonTitles:其他按钮上的文字
 *  @param  tapBlock:点击block
 *  return  点击事件以block实现的弹框
 */
+ (instancetype)qgocc_showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(qgocc_UIAlertViewTapBlock)tapBlock;

@property (nonatomic, copy) qgocc_UIAlertViewTapBlock qgocc_tapBlock;
@end
