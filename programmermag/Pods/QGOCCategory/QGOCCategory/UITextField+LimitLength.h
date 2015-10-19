//
//  UITextField+LimitLength.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/3.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)

/**
 *  获取输入框最多可以输入的字数
 *  return  最多可以输入的字数。
 */
- (NSInteger)qgocc_limitLengthNum;

/**
 *  设置输入框最多输入的字数
 *  @param  length：最大输入的字数
 */
- (void)qgocc_setLimitTextLength:(NSInteger)length;
@end
