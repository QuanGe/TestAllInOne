//
//  PMBookPaperCollectionViewCell.m
//  programmermag
//
//  Created by 张如泉 on 15/11/3.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookPaperCollectionViewCell.h"
#import "PMBookPaperColumnView.h"
#import "PMArticlePaperModel.h"
#import "PMArticleImageModel.h"
@interface PMBookPaperCollectionViewCell()

@end

@implementation PMBookPaperCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor orangeColor];
        [self buildChildView];
    }
    return self;
}

- (void)buildChildView
{
    PMBookPaperColumnView * left = [[PMBookPaperColumnView alloc] init];
    {
        [self addSubview:left];
        left.backgroundColor = [UIColor clearColor];
        [left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(mScreenWidth/2);
        }];
        
        
    }
    
    PMBookPaperColumnView * right = [[PMBookPaperColumnView alloc] init];
    {
        [self addSubview:right];
        right.backgroundColor = [UIColor clearColor];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mScreenWidth/2);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        
    }
    
    UIImageView * home = [[UIImageView alloc] init];
    {
        [self addSubview:home];
        home.hidden = YES;
        [home mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    
    
    [RACObserve(self, paperModel) subscribeNext:^(PMArticlePaperModel * paper) {
        if(paper == nil)
            return ;
        
        if(paper.type == PMArticlePaperTypeOnlyImage)
        {
            home.hidden = NO;
            home.image = [UIImage imageNamed:paper.ortherImage.imageFileName];
        }
        else
        {
            home.hidden = YES;
            left.ctFrame = paper.leftCTFrame;
            left.images = paper.leftImageArray;
            
            
            right.ctFrame = paper.rightCTFrame;
            right.images = paper.rightImageArray;
            [left setNeedsDisplay];
            [right setNeedsDisplay];
        }
    }];
    
    

}

@end
