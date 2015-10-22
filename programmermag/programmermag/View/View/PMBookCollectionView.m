//
//  PMBookCollectionView.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookCollectionView.h"
@interface PMBookCollectionView()
@property (nonatomic,readwrite,strong) UIImageView * tipImageView;
@property (nonatomic,readwrite,strong) UIProgressView * downloadProgressView;
@property (nonatomic,readwrite,strong) UILabel *downloadLabel;
@end
@implementation PMBookCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor orangeColor];
        [self buildChildView];
    }
    return self;
}

- (void)buildChildView
{
    self.issueImageView = [[UIImageView alloc] init];
    {
        [self addSubview:self.issueImageView];
        [self.issueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            self.issueImageViewHeight = make.height.mas_equalTo(150);
        }];
    }
    
    self.issueTitleLable = [[UILabel alloc] init];
    {
        [self addSubview:self.issueTitleLable];
        self.issueTitleLable.textColor = kBlackColor;
        self.issueTitleLable.font = [UIFont systemFontOfSize:12];
        self.issueTitleLable.text = @"程序猿杂志";
    
        
        [self.issueTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    self.issueEditionLable = [[UILabel alloc] init];
    {
        [self addSubview:self.issueEditionLable];
        self.issueEditionLable.textColor = [UIColor grayColor];
        self.issueEditionLable.font = [UIFont systemFontOfSize:10];
        self.issueEditionLable.text = @"2015.10.a";
        
        
        [self.issueEditionLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.issueTitleLable.mas_bottom).offset(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    
    self.issuePriceLable = [[UILabel alloc] init];
    {
        [self addSubview:self.issuePriceLable];
        [self.issuePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.issueEditionLable.mas_bottom).offset(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    
    self.issueDesLable = [[UILabel alloc] init];
    {
        [self addSubview:self.issueDesLable];
        self.issueEditionLable.textColor = kBlackColor;
        self.issueEditionLable.font = [UIFont systemFontOfSize:10];
        [self.issueDesLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.issuePriceLable.mas_bottom).offset(20);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    
    self.tipImageView = [[UIImageView alloc] init];
    {
        [self addSubview:self.tipImageView];
        [self.tipImageView setImage:[UIImage imageNamed:@"newtag60"]];
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
    }

    self.downloadProgressBoxView = [[UIView alloc] init];
    {
        
        [self addSubview:self.downloadProgressBoxView];
        self.downloadProgressView = [[UIProgressView alloc] init];
        {
        
            [self.downloadProgressBoxView addSubview:self.downloadProgressView];
            [self.downloadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(20);
            }];
        }
        self.downloadLabel = [[UILabel alloc] init];
        {
            self.downloadLabel.textColor = kBlackColor;
            self.downloadLabel.font = [UIFont systemFontOfSize:10];
            [self.downloadProgressBoxView addSubview:self.downloadLabel];
            [self.downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(20);
            }];
            
        }
        [self.downloadProgressBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-100);
            make.right.mas_equalTo(60);
            make.height.mas_equalTo(50);
        }];
    }
}

- (void)updateDownloadProgress:(CGFloat)progress labelText:(NSAttributedString*)text
{
    self.downloadProgressView.progress = progress;
    self.downloadLabel.attributedText = text;
}

- (void)changeBig:(BOOL)big
{
    self.tipImageView.hidden = !big;
    self.issueDesLable.hidden = !big;
}

@end
