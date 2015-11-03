//
//  PMArticlePaperModel.m
//  programmermag
//
//  Created by 张如泉 on 15/11/3.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMArticlePaperModel.h"
@interface PMArticlePaperModel()
@property (nonatomic,readwrite,assign) PMArticlePaperType type;
@end
@implementation PMArticlePaperModel
- (instancetype)initWithType:(PMArticlePaperType)type
{
    self = [super init];
    if(self)
    {
        self.type = type;
    }
    return self;
}
@end
