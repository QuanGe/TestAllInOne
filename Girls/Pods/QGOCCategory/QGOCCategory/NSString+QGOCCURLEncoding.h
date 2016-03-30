//
//  NSString+QGOCCURLEncoding.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/6.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QGOCCURLEncoding)

/**
 * Encodes URL字符串
 * @returns The string encoded for use in a URL
 **/
- (NSString *)URLEncodedString;

/**
 * Decodes URL字符串
 * @returns The decoded string
 **/
- (NSString *)URLDecodedString;
@end
