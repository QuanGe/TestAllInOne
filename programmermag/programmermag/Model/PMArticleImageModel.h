//
//  PMArticleImageModel.h
//  programmermag
//
//  Created by 张如泉 on 15/11/2.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,PMArticleImageType)
{
    PMArticleImageTypeContentNoImage,
    PMArticleImageTypeContentImage,
    PMArticleImageTypeContentCodeLink,
    PMArticleImageTypeContentStaticImage,
    PMArticleImageTypeContentHomeImage,
    PMArticleImageTypeContentVideo
} ImageType;
@interface PMArticleImageModel : NSObject
@property (nonatomic,readwrite,assign) PMArticleImageType type;
@property (nonatomic,readwrite,strong) NSString* imageFileName;
@property (nonatomic,readwrite,strong) NSString* cickImageFileName;
@property (nonatomic,readwrite,strong) NSString* imageCaption;
@property (nonatomic,readwrite,assign) float height;
@property (nonatomic,readwrite,assign) int colspan;
@property (nonatomic,readwrite,assign) int location;
@end
