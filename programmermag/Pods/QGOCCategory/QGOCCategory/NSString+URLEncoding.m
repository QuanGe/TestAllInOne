//
//  NSString+URLEncoding.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/6.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

/**
 * Encodes URL字符串
 * @returns The string encoded for use in a URL
 **/
- (NSString *)URLEncodedString
{
    __autoreleasing NSString *encodedString;
    NSString *originalString = (NSString *)self;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)originalString,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}

/**
 * Decodes URL字符串
 * @returns The decoded string
 **/
- (NSString *)URLDecodedString
{
    __autoreleasing NSString *decodedString;
    NSString *originalString = (NSString *)self;
    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                          NULL,
                                                                                                          (__bridge CFStringRef)originalString,
                                                                                                          CFSTR(""),
                                                                                                          kCFStringEncodingUTF8
                                                                                                          );
    return decodedString;
}
@end
