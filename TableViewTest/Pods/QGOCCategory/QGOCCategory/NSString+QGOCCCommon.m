//
//  NSString+QGOCCCommon.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/15.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSString+QGOCCCommon.h"

@implementation NSString (QGOCCCommon)

/**
 *  在NSString后面添加单词，使单词内不存在换行
 *  @param  word:单词
 *  @param  width:文字显示控件UI的宽度
 *  @param  fontSize:文字大小
 *  return  插入后的文字
 */
- (NSString*)qgocc_addStringByWord:(NSString *)word viewWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] }
                                         context:nil];
    CGRect addedTextRect = [[self stringByAppendingString:word] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] }
                                         context:nil];
    
    if(addedTextRect.size.height == textRect.size.height)
        return [self stringByAppendingString:word];
    else
        return [[self stringByAppendingString:@"\n"] stringByAppendingString:word];

}

@end
