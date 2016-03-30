//
//  UIColor+QGOCCCommon.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIColor+QGOCCCommon.h"

@implementation UIColor (QGOCCCommon)

/**
 *  根据十六进制颜色值返回UIColor。
 *  @param  hexColor:十六进制颜色值。
 *  return  UIColor。
 */
+ (UIColor *)qgocc_colorFromHexColor:(NSInteger)hexColor
{
    return [UIColor colorWithRed:((float) ((hexColor & 0xFF0000) >> 16)) / 0xFF
                           green:((float) ((hexColor & 0xFF00)   >> 8))  / 0xFF
                            blue:((float)  (hexColor & 0xFF))            / 0xFF
                           alpha:1.0];
}
@end
