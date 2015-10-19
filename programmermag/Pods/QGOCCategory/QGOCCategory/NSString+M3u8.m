//
//  NSString+M3u8.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/4.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSString+M3u8.h"

@implementation NSString (M3u8)

/**
 *  将M3u8内容字符串转换为字典
 *
 *  return M3u8转化后的字典
 */
- (NSDictionary*)qgocc_dictionaryFromM3u8Str
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString *m3u8FirstTag = @"#EXTM3U";
    NSRange rangeOfEXTM3U = [self rangeOfString:m3u8FirstTag];
    if (rangeOfEXTM3U.location == NSNotFound ||
        rangeOfEXTM3U.location != 0) {
        return nil;
    }
    
    NSArray * lineArray = [self componentsSeparatedByString:@"\n"];
    
    NSMutableArray * videos = [NSMutableArray array];
    [dic setObject:videos forKey:@"videos"];
    NSMutableArray* videoSegs = nil;
    NSMutableDictionary *videoSeg = nil;
    
    NSInteger videoSegCount = 0;
    
    NSMutableArray * videoKeys = [NSMutableArray array];
    for (NSString* lineStr in lineArray) {
        
        if([lineStr isEqualToString:@""])
        {
            continue;
        }
        else if([lineStr isEqualToString:@"#EXTM3U"])
        {
            continue;
        }
        else if([lineStr isEqualToString:@"#EXT-X-DISCONTINUITY" ])
        {
            if(videoSeg)
            {
                [videoSegs addObject:videoSeg];
                videoSeg = nil;
            }
            if(videoSegs)
                [videos addObject:videoSegs];
            videoSegs = [NSMutableArray array];
        }
        else if([lineStr rangeOfString:@":"].location != NSNotFound)
        {
            NSArray * keyAndValue = [lineStr componentsSeparatedByString:@":"];
            
            if([keyAndValue[0] isEqualToString:@"#EXT-X-TARGETDURATION"])
            {
                [dic setObject:keyAndValue[1] forKey:keyAndValue[0]];
            }
            
            else if([keyAndValue[0] isEqualToString:@"#EXT-X-KEY"])
            {
                if(videoSeg)
                    [videoSegs addObject:videoSeg];
                videoSeg = [NSMutableDictionary dictionary];
                videoSegCount++;
                NSArray * allkey = [[lineStr substringFromIndex:11] componentsSeparatedByString:@","];
                for (NSString * keyValue in allkey) {
                    NSArray * keyAndValueChild = [keyValue componentsSeparatedByString:@"="];
                    
                    [videoSeg setObject:keyAndValueChild[1] forKey:keyAndValueChild[0]];
                    
                    if([keyAndValueChild[0] isEqualToString:@"URI"])
                    {
                        NSString * videokey = [keyAndValueChild[1] substringFromIndex:1];
                        videokey = [videokey substringToIndex:videokey.length - 1];
                        if(![videoKeys containsObject:videokey])
                            [videoKeys addObject:videokey];
                    }
                }
                
                
            }
            
            else if([keyAndValue[0] isEqualToString:@"#EXTINF"])
            {
                [videoSeg setObject:[keyAndValue[1] substringToIndex:[keyAndValue[1] length]-1] forKey:keyAndValue[0]];
                
            }
            else if ([keyAndValue[0] isEqualToString:@"http"])
            {
                
                [videoSeg setObject:lineStr forKey:@"videoSegUrl"];
            }
        }
        else if([lineStr isEqualToString:@"#EXT-X-ENDLIST"])
        {
            if(videoSeg)
                [videoSegs addObject:videoSeg];
            if(videoSegs)
                [videos addObject:videoSegs];
            
        }
        else
        {
            [videoSeg setObject:lineStr forKey:@"videoSegUrl"];
        }
        
    }
    [dic setObject:videoKeys forKey:@"videoKeys"];
    [dic setObject:@(videoSegCount) forKey:@"videoSegCount"];
    return dic;
}

@end
