//
//  NSString+QGOCCMD5.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QGOCCMD5)

/**
 *  对字符串进行MD5加密
 *  return  加密后的字符串
 */
- (NSString *)qgocc_stringFromMD5;
@end
