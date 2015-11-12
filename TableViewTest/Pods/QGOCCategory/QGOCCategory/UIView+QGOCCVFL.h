//
//  UIView+QGOCCVFL.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/8.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QGOCCVFL)

/**
 *  以VFL方式实现自动布局
 *  @param  parentView:父view
 *  @param  rect:左上边距 和 宽高
 *  @param  margin:右下边距
 *  return  所有Constraints组成的数组NSArray
 */
- (NSArray *)qgocc_configConstraintsWithParentView:(UIView *)parentView rect:(CGRect)rect marginRightAndBottom:(CGPoint)margin;
@end
