//
//  PMArticlePaperModel.h
//  programmermag
//
//  Created by 张如泉 on 15/11/3.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PMArticleImageModel;
typedef NS_ENUM(NSInteger,PMArticlePaperType)
{
    PMArticlePaperTypeOnlyImage,//只有图片，UI需要单独布局
    PMArticlePaperTypeFisrtPagerNormal,//文章首页 最普通的  UI需要单独布局
    PMArticlePaperTypeFisrtPagerBigImage,//文章首页 带占两列大图， UI需要单独布局
    PMArticlePaperTypeFisrtPagerSmallImage,//文章首页 在右侧半部分， UI需要单独布局
    PMArticlePaperTypeNormal//普通页
};
@interface PMArticlePaperModel : NSObject
- (instancetype)initWithType:(PMArticlePaperType)type;
@property (nonatomic,readwrite,assign) PMArticlePaperType type;
@property (nonatomic,readwrite,strong) id leftCTFrame;
@property (nonatomic,readwrite,strong) id rightCTFrame;
@property (nonatomic,readwrite,strong) NSMutableArray *leftImageArray;
@property (nonatomic,readwrite,strong) NSMutableArray *rightImageArray;
@property (nonatomic,readwrite,strong) PMArticleImageModel *ortherImage;
@end
