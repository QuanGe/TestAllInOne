//
//  PMBookCollectionViewCell.h
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMBookCollectionViewCell : UICollectionViewCell
@property (nonatomic,readwrite,strong) UIButton * issueImageBtn;
@property (nonatomic,readwrite,strong) UILabel * issueTitleLable;
@property (nonatomic,readwrite,strong) UILabel * issueEditionLable;
@property (nonatomic,readwrite,strong) UILabel * issuePriceLable;
@property (nonatomic,readwrite,strong) UILabel * issueDesLable;
@property (nonatomic,readwrite,strong) UIButton * downReadBuyBtn;
@property (nonatomic,readwrite,strong) UIButton * deleteBtn;
@property (nonatomic,readwrite,strong) UIView * downloadProgressBoxView;
@property (nonatomic,readwrite,strong) MASConstraint * issueImageViewWidth;
- (void)updateDownloadProgress:(CGFloat)progress labelText:(NSAttributedString*)text;
- (void)changeBig:(BOOL)big;
- (void)changeDownBtnType:(NSInteger)type;
@end
