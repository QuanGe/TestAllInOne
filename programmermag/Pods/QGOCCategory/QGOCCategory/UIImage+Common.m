//
//  UIImage+Common.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

/**
 *  根据颜色获取图片
 *  @param  color: 目标色彩。 size:大小
 *  return  根据颜色生成的图片
 */
+ (UIImage *)qgocc_imageWithColor:(UIColor *)color size:(CGSize)size
{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
    
}

/**
 *  改变一个Image的色彩。
 *  @param  color: 要改变的目标色彩。
 *  return  色彩更改后的Image。
 */
- (UIImage *)qgocc_imageMaskedWithColor:(UIColor *)maskColor
{
    NSParameterAssert(maskColor != nil);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, imageRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  生成九宫格图片。
 *  @param  flip: 是否旋转
 *  return  九宫格图片
 */
- (UIImage *)qgocc_convert9ScaleUIImage:(BOOL)flip
{
    UIImage * image = nil;
    if(flip)
        image = [UIImage imageWithCGImage:self.CGImage
                                    scale:self.scale
                              orientation:UIImageOrientationUpMirrored];
    else
        image = self;
    CGPoint center = CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y/2.0f, center.x/2.0f);
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    
}

/**
 *  获取圆角图片
 *  @param  cornerRadius: 圆角半径
 *  return  圆角图片
 */
- (UIImage *)qgocc_clipImageWithCornerRadius:(CGFloat)cornerRadius
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    
    if (cornerRadius > MIN(w, h))
        cornerRadius = MIN(w, h) / 2.;
    
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:w*cornerRadius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

/**
 *  裁减图片
 *  @param  frame: 裁减部分位置大小
 *  return  裁减后的图片
 */
- (UIImage *)qgocc_captureImageWithFrame:(CGRect)frame
{
    CGImageRef imageRef = nil;
    imageRef = CGImageCreateWithImageInRect([self CGImage], frame);
    return [UIImage imageWithCGImage:imageRef];
    
}

/**
 *  合并两个Image。
 *  @param  image1、image2: 两张图片。
 *  @param  frame1、frame2:两张图片放置的位置。
 *  @param  size:返回图片的尺寸。
 *  return  合并后的两个图片的Image。
 */
+ (UIImage *)qgocc_mergeWithImage1:(UIImage *)image1 image2:(UIImage *)image2 frame1:(CGRect)frame1 frame2:(CGRect)frame2 size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:frame1 blendMode:kCGBlendModeLuminosity alpha:1.0];
    [image2 drawInRect:frame2 blendMode:kCGBlendModeLuminosity alpha:0.2];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
