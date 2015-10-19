//
//  NSString+Regular.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

/**
 *  邮箱符合性验证
 *
 */
- (BOOL)qgocc_isValidateEmail
{
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  是否全是数字
 *
 */
- (BOOL)qgocc_isNumber
{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  验证英文字母。
 *
 */
- (BOOL)qgocc_isEnglishWords
{
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  验证密码：6—16位，只能包含字符、数字和 下划线
 *
 */
- (BOOL)qgocc_isValidatePassword
{
    NSString *regex = @"^[\\w\\d_]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  验证是否为汉字
 *
 */
- (BOOL)qgocc_isChineseWords
{
    NSString *regex = @"^[\u4e00-\u9fa5],{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  验证是否为网络链接
 *
 */
- (BOOL)qgocc_isInternetUrl
{
    NSString *regex = @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$ ；^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  验证是否为电话号码。正确格式为：XXXX-XXXXXXX，XXXX-XXXXXXXX，XXX-XXXXXXX，XXX-XXXXXXXX，XXXXXXX，XXXXXXXX
 *
 */
- (BOOL)qgocc_isPhoneNumber
{
    NSString *regex = @"^(\(\\d{3,4}\\)|\\d{3,4}-)?\\d{7,8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  判断是否为11位的数字
 *
 */
- (BOOL)qgocc_isElevenDigitNum
{
    NSString *regex = @"^[0-9]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    
    if (result && self.length == 11)
        return YES;
    
    return NO;
}

/**
 *  验证15或18位身份证
 *
 */
- (BOOL)qgocc_isIdentifyCardNumber
{
    NSString *regex = @"^\\d{15}|\\d{}18$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
@end
