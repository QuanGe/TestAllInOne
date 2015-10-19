//
//  NSMutableAttributedString+Common.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/16.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSMutableAttributedString+Common.h"

@implementation NSMutableAttributedString (Common)

/**
 *  在NSString后面添加单词，使单词内不存在换行
 *  @param  word:单词
 *  @param  width:文字显示控件UI的宽度
 *  @param  fontSize:文字大小
 *  return  插入后的文字
 */
- (NSMutableAttributedString*)qgocc_addStringByWord:(NSMutableAttributedString *)word viewWidth:(CGFloat)width
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    NSMutableAttributedString * addedText = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [addedText appendAttributedString:word];
    CGRect addedTextRect = [addedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    NSMutableAttributedString * addEnter = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    if(textRect.size.height == addedTextRect.size.height)
    {
        
        return addedText;
    }
    else
    {
        [addEnter appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        [addEnter appendAttributedString:word];
        return addEnter;
    }
    
}
@end
