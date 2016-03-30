//
//  NSString+QGOCCAES256.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QGOCCAES256)

/**
 *  对字符串进行AES256加密
 *  @param  key：加密钥匙
 *  return  加密后的字符串
 */
- (NSString *)qgocc_aes256_encrypt:(NSString *)key;

/**
 *  对字符串进行AES256解密
 *  @param  key：加密钥匙
 *  return  解密后的字符串
 */
- (NSString *)qgocc_aes256_decrypt:(NSString *)key;
@end
