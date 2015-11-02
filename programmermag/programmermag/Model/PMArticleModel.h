//
//  PMArticleModel.h
//  programmermag
//
//  Created by 张如泉 on 15/11/2.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PMArticleImageModel;
@interface PMArticleModel : NSObject
@property (nonatomic,readwrite,copy) NSString* titile;
@property (nonatomic,readwrite,copy) NSString* subTitile;
@property (nonatomic,readwrite,copy) NSString* editor;
@property (nonatomic,readwrite,copy) NSString* articleDescription;
@property (nonatomic,readwrite,copy) NSString* type;
@property (nonatomic,readwrite,copy) NSString* category;
@property (nonatomic,readwrite,copy) NSString* pubDate;

@property (nonatomic,readwrite,strong) NSMutableAttributedString* content;
@property (nonatomic,readwrite,strong) NSMutableAttributedString* headerStr;
@property (nonatomic,readwrite,strong) NSMutableArray* images;
@property (nonatomic,readwrite,strong) PMArticleImageModel* staticImage;

@end
