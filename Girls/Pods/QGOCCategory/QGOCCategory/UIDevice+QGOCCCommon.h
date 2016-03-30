//
//  UIDevice+QGOCCCommon.h
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (QGOCCCommon)

/**
 *  获取设备型号
 *  return  设备型号字符串
 */
+ (NSString *)qgocc_deviceVersion;

/**
 *  获取iOS系统版本
 *  return  iOS系统版本
 */
+ (NSString*)qgocc_systemVersion;

/**
 *  获取APP版本
 *  return  APP版本
 */
+ (NSString*)qgocc_appVersion;

/**
 *  设备是否为iPad
 *  return  设备是否为iPad
 */
+ (BOOL)qgocc_isIpad;

/**
 *  设备是否为iPhone
 *  return  设备是否为iPhone
 */
+ (BOOL)qgocc_isIPhone;

/**
*  判断是否为Retina屏幕
*  return  是否为Retina屏幕
*/
+ (CGFloat)qgocc_isRetina;

/**
 *  获取设备唯一标示
 *  return  设备唯一标示
 */
+ (NSString *)qgocc_uniqueDeviceIdentifier;

/**
 *  获取设备硬盘容量
 *  return  硬盘容量(单位：M)
 */
+ (NSString *)qgocc_totalDiskSpaceBytes;

/**
 *  获取设备硬盘空闲容量
 *  return  硬盘空闲容量(单位：M)
 */
+ (NSString *)qgocc_freeDiskSpaceBytes;



@end
