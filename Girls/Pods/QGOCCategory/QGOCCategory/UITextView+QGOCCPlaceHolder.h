//
//  UITextView+QGOCCPlaceHolder.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/8.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (QGOCCPlaceHolder)

/**
 *  设置默认文本
 *  @param  placeholder:默认文本
 *  return  无
 */
- (void)qgocc_setPlaceHolder:(NSString*)placeholder;

/**
 *  设置最大文字数量限制
 *  @param  maxLengthNum:最大文字数量限制
 *  return  无
 */
- (void)qgocc_setMaxLengthNum:(NSInteger)maxLengthNum;

/**
 *  获取默认文本
 *  return  默认文本
 */
- (NSString *)qgocc_placeholder;

/**
 *  获取文字数量限制
 *  return  文字数量限制
 */
- (NSInteger)qgocc_maxLengthNum;


@end
