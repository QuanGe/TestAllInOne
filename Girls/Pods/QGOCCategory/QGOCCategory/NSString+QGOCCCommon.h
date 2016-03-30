//
//  NSString+QGOCCCommon.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/15.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (QGOCCCommon)

/**
 *  在NSString后面添加单词，使单词内不存在换行
 *  @param  word:单词
 *  @param  width:文字显示控件UI的宽度
 *  @param  fontSize:文字大小
 *  return  插入后的文字
 */
- (NSString*)qgocc_addStringByWord:(NSString *)word viewWidth:(CGFloat)width fontSize:(CGFloat)fontSize;
@end
