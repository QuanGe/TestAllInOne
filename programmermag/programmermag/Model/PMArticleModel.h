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
@property (nonatomic,strong) NSString* titile;
@property (nonatomic,strong) NSString* subTitile;
@property (nonatomic,strong) NSString* editor;
@property (nonatomic,strong) NSString* articleDescription;
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSString* mcategory;
@property (nonatomic,strong) NSString* pubDate;

@property (nonatomic,strong) NSMutableAttributedString* content;
@property (nonatomic,strong) NSMutableAttributedString* headerStr;
@property (nonatomic,strong) NSMutableArray* images;
@property (nonatomic,strong) PMArticleImageModel* staticImage;

@end
