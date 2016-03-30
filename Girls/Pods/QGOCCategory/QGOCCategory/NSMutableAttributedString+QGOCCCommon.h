//
//  NSMutableAttributedString+QGOCCCommon.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/16.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (QGOCCCommon)

/**
 *  在富文本NSString后面添加单词，使单词内不存在换行
 *  @param  word:单词
 *  @param  width:文字显示控件UI的宽度
 *  return  插入后的文字
 */
- (NSMutableAttributedString*)qgocc_addStringByWord:(NSMutableAttributedString *)word viewWidth:(CGFloat)width;
@end
