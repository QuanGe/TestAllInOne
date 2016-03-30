//
//  NSString+QGOCCMD5.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSString+QGOCCMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (QGOCCMD5)

/**
 *  对字符串进行MD5加密
 *  return  加密后的字符串
 */
- (NSString *)qgocc_stringFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;

    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;

}
@end
