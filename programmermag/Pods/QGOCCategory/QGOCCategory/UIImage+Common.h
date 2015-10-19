//
//  UIImage+Common.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

/**
 *  根据颜色获取图片
 *  @param  color: 目标色彩。 size:大小
 *  return  根据颜色生成的图片
 */
+ (UIImage *)qgocc_imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  改变一个Image的色彩。
 *  @param  color: 要改变的目标色彩。
 *  return  色彩更改后的Image。
 */
- (UIImage *)qgocc_imageMaskedWithColor:(UIColor *)maskColor;

/**
 *  生成九宫格图片。
 *  @param  flip: 是否旋转
 *  return  九宫格图片
 */
- (UIImage *)qgocc_convert9ScaleUIImage:(BOOL)flip;

/**
 *  获取圆角图片
 *  @param  cornerRadius: 圆角半径
 *  return  圆角图片
 */
- (UIImage *)qgocc_clipImageWithCornerRadius:(CGFloat)cornerRadius;
@end
