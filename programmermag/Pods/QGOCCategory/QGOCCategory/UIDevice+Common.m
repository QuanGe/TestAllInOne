//
//  UIDevice+Common.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "UIDevice+Common.h"
#import <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#include <net/if_dl.h>
#import "NSString+MD5.h"

@implementation UIDevice (Common)

/**
 *  获取设备型号
 *  return  设备型号字符串
 */
+ (NSString *)qgocc_deviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
    
}

/**
 *  获取iOS系统版本
 *  return  iOS系统版本
 */
+ (NSString*)qgocc_systemVersion
{
    return [[UIDevice currentDevice]systemVersion];
}

/**
 *  获取APP版本
 *  return  APP版本
 */
+ (NSString*)qgocc_appVersion
{
    return [[NSBundle mainBundle]
            objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

/**
 *  设备是否为iPad
 *  return  设备是否为iPad
 */
+ (BOOL)qgocc_isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

/**
 *  设备是否为iPhone
 *  return  设备是否为iPhone
 */
+ (BOOL)qgocc_isIPhone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}


/**
 *  获取设备唯一标示
 */
+ (NSString *)qgocc_uniqueDeviceIdentifier
{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash qgocc_stringFromMD5];
    return uniqueIdentifier;
}

/**
 *  获取设备硬盘容量
 *  return  硬盘容量(单位：M)
 */
+ (NSString *)qgocc_totalDiskSpaceBytes
{
    NSDictionary *fattributes = [[ NSFileManager defaultManager ] attributesOfFileSystemForPath : NSHomeDirectory () error : nil ];
    CGFloat num = [[fattributes objectForKey : NSFileSystemSize ] floatValue]/1024.0/1024.0;
    return [NSString stringWithFormat:@"%.1f%@",num>1024?num/1024.0:num,num>1024?@"G":@"M"];
    
}

/**
 *  获取设备硬盘空闲容量
 *  return  硬盘空闲容量(单位：M)
 */
+ (NSString *)qgocc_freeDiskSpaceBytes
{
    NSDictionary *fattributes = [[ NSFileManager defaultManager ] attributesOfFileSystemForPath : NSHomeDirectory () error : nil ];
    CGFloat num = [[fattributes objectForKey : NSFileSystemFreeSize ] floatValue]/1024.0/1024.0;
    return [NSString stringWithFormat:@"%.1f%@",num>1024?num/1024.0:num,num>1024?@"G":@"M"];
    
}
@end
