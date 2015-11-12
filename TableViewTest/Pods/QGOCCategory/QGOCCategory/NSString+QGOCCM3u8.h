//
//  NSString+QGOCCM3u8.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QGOCCM3u8)

/**
 *  将M3u8内容字符串转换为字典
 *  
 *  return M3u8转化后的字典
 */
- (NSDictionary*)qgocc_dictionaryFromM3u8Str;
@end
