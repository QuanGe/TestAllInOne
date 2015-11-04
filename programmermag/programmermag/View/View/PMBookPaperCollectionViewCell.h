//
//  PMBookPaperCollectionViewCell.h
//  programmermag
//
//  Created by 张如泉 on 15/11/3.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PMArticlePaperModel;
@interface PMBookPaperCollectionViewCell : UICollectionViewCell
@property (nonatomic,readwrite,strong) PMArticlePaperModel *paperModel;
@property (nonatomic,readwrite,strong) UILabel * titleLabel;
@end
