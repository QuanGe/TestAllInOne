//
//  PMBookCollectionView.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookCollectionViewCell.h"
#define kBigImageWidth 300
#define kSmallImageWidth 130

@interface PMBookCollectionViewCell()
@property (nonatomic,readwrite,strong) UIImageView * tipImageView;
@property (nonatomic,readwrite,strong) UIProgressView * downloadProgressView;
@property (nonatomic,readwrite,strong) UILabel *downloadLabel;
@end
@implementation PMBookCollectionViewCell

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
    UIView * backgroundView = [[UIView alloc] init];
    {
        [self addSubview:backgroundView];
        backgroundView.backgroundColor = mRGBColor(240, 240, 240);
        
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];

        
    }
    
    self.issueImageBtn = [[UIButton alloc] init];
    {
        [backgroundView addSubview:self.issueImageBtn];
        [self.issueImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            self.issueImageViewWidth = make.width.mas_equalTo(100);
        }];
    }
    
    self.issueTitleLable = [[UILabel alloc] init];
    {
        [backgroundView addSubview:self.issueTitleLable];
        self.issueTitleLable.textColor = kBlackColor;
        self.issueTitleLable.font = [UIFont systemFontOfSize:12];
        self.issueTitleLable.text = @"程序猿杂志";
    
        
        [self.issueTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageBtn.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    self.issueEditionLable = [[UILabel alloc] init];
    {
        [backgroundView addSubview:self.issueEditionLable];
        self.issueEditionLable.textColor = [UIColor grayColor];
        self.issueEditionLable.font = [UIFont systemFontOfSize:10];
        self.issueEditionLable.text = @"2015.10.a";
        
        
        [self.issueEditionLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.issueTitleLable.mas_bottom).offset(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageBtn.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    
    self.issuePriceLable = [[UILabel alloc] init];
    {
        [backgroundView addSubview:self.issuePriceLable];
        [self.issuePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.issueEditionLable.mas_bottom).offset(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageBtn.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    
    __block MASConstraint *desHeight;
    self.issueDesLable = [[UILabel alloc] init];
    {
        [backgroundView addSubview:self.issueDesLable];
        self.issueDesLable.hidden = YES;
        self.issueDesLable.numberOfLines = 0;
        self.issueDesLable.textColor = kBlackColor;
        self.issueDesLable.font = [UIFont systemFontOfSize:14];
        [self.issueDesLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.issuePriceLable.mas_bottom).offset(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.issueImageBtn.mas_right).offset(10);
            desHeight= make.height.mas_equalTo(20);
        }];
        [RACObserve(self.issueDesLable, text) subscribeNext:^(NSString *x) {
            CGRect tr = [x boundingRectWithSize:CGSizeMake(mScreenWidth-kBigImageWidth-20, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : self.issueDesLable.font } context:nil];
            desHeight.mas_equalTo (tr.size.height+10);
        }];
        
    }
    
    self.tipImageView = [[UIImageView alloc] init];
    {
        [backgroundView addSubview:self.tipImageView];
        self.tipImageView.hidden = YES;
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
        self.downloadProgressBoxView.hidden =YES;
        [backgroundView addSubview:self.downloadProgressBoxView];
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
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    
    self.downReadBuyBtn = [[UIButton alloc] init];
    {
        [backgroundView addSubview:self.downReadBuyBtn];
        [self.downReadBuyBtn setBackgroundImage:[UIImage imageNamed:@"bluebuttonbkg"] forState:UIControlStateNormal];
        [self.downReadBuyBtn setTitle:@"下载" forState:UIControlStateNormal];
        self.downReadBuyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.downReadBuyBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.downReadBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(50);
            make.left.equalTo(self.issueImageBtn.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
    }
    
    self.deleteBtn = [[UIButton alloc] init];
    {
        self.deleteBtn.hidden = YES;
        [backgroundView addSubview:self.deleteBtn];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"graybuttonbkg"] forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.deleteBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(50);
            make.left.equalTo(self.downReadBuyBtn.mas_right).offset(20);
            make.height.mas_equalTo(20);
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
    self.issueImageViewWidth.mas_equalTo(big?kBigImageWidth:kSmallImageWidth);
}

- (void)changeDownBtnType:(NSInteger)type
{
    switch (type) {
        case 0:
            [self.downReadBuyBtn setBackgroundImage:[UIImage imageNamed:@"bluebuttonbkg"] forState:UIControlStateNormal];
            [self.downReadBuyBtn setTitle:@"下载" forState:UIControlStateNormal];
            self.deleteBtn.hidden = YES;
            break;
        case 1:
            [self.downReadBuyBtn setBackgroundImage:[UIImage imageNamed:@"orangebtnbkg"] forState:UIControlStateNormal];
            [self.downReadBuyBtn setTitle:@"购买" forState:UIControlStateNormal];
            self.deleteBtn.hidden = YES;
            break;
        case 2:
            [self.downReadBuyBtn setBackgroundImage:[UIImage imageNamed:@"bluebuttonbkg"] forState:UIControlStateNormal];
            [self.downReadBuyBtn setTitle:@"阅读" forState:UIControlStateNormal];
            self.deleteBtn.hidden = NO;
            break;
        default:
            break;
    }
}

@end
