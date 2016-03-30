//
//  NSString+QGOCCRegular.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QGOCCRegular)

/**
 *  邮箱符合性验证
 *
 */
- (BOOL)qgocc_isValidateEmail;

/**
 *  是否全是数字
 *
 */
- (BOOL)qgocc_isNumber;

/**
 *  验证英文字母。
 *
 */
- (BOOL)qgocc_isEnglishWords;

/**
 *  验证密码：6—16位，只能包含字符、数字和 下划线
 *
 */
- (BOOL)qgocc_isValidatePassword;

/**
 *  验证是否为汉字
 *
 */
- (BOOL)qgocc_isChineseWords;

/**
 *  验证是否为网络链接
 *
 */
- (BOOL)qgocc_isInternetUrl;

/**
 *  验证是否为电话号码。正确格式为：XXXX-XXXXXXX，XXXX-XXXXXXXX，XXX-XXXXXXX，XXX-XXXXXXXX，XXXXXXX，XXXXXXXX
 *
 */
- (BOOL)qgocc_isPhoneNumber;

/**
 *  判断是否为11位的数字
 *
 */
- (BOOL)qgocc_isElevenDigitNum;

/**
 *  验证15或18位身份证
 *
 */
- (BOOL)qgocc_isIdentifyCardNumber;
@end
