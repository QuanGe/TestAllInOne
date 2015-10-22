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

/**
 *  裁减图片
 *  @param  frame: 裁减部分位置大小
 *  return  裁减后的图片
 */
- (UIImage *)qgocc_captureImageWithFrame:(CGRect)frame;

/**
 *  合并两个Image。
 *  @param  image1、image2: 两张图片。
 *  @param  frame1、frame2:两张图片放置的位置。
 *  @param  size:返回图片的尺寸。
 *  return  合并后的两个图片的Image。
 */
+ (UIImage *)qgocc_mergeWithImage1:(UIImage *)image1 image2:(UIImage *)image2 frame1:(CGRect)frame1 frame2:(CGRect)frame2 size:(CGSize)size;

@end
