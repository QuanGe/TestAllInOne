//
//  PMHomeBaseViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMHomeBaseViewController.h"
#import "PMBookCollectionViewCell.h"
#import "RFQuiltLayout.h"
@interface PMHomeBaseViewController()

@end
@implementation PMHomeBaseViewController
- (void)loadView
{
    [super loadView];
    UIImageView * titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100 , 31)];
    {
        [titleView setImage:[UIImage imageNamed:@"logo_s"]];
        [self.navigationItem setTitleView:titleView];
    }
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65 , 25)];
    {
        leftBtn.layer.backgroundColor = mRGBColor(235 , 235, 235).CGColor;
        leftBtn.layer.cornerRadius = 2;
        [leftBtn setTitle:@"恢复购买" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        UIBarButtonItem *leftView = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftView];
    }
    
    RFQuiltLayout *recommentLayout=[[RFQuiltLayout alloc] init];
    {
        recommentLayout.direction = UICollectionViewScrollDirectionHorizontal;
        recommentLayout.delegate = self;
        recommentLayout.blockPixels = CGSizeMake(mScreenWidth/2, 100);
        self.dataView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:recommentLayout];
        self.dataView.backgroundColor = [UIColor whiteColor];
        self.dataView.pagingEnabled = YES;
        [self.dataView setDataSource:self];
        [self.dataView setDelegate:self];
        [self.dataView registerClass:objc_getClass("PMBookCollectionViewCell") forCellWithReuseIdentifier:@"PMBookCollectionViewCell"];
        [self.dataView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
        [self.view addSubview:self.dataView];
        [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-60);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(60);
        }];
    }

    self.viewModel = [[PMBookViewModel alloc] init];
}

#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numOfBook];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PMBookCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PMBookCollectionViewCell" forIndexPath:indexPath];
    
    cell.issueTitleLable.text = [self.viewModel titleOfBookWithIndex:indexPath.row];
    cell.issueEditionLable.text = [self.viewModel editionOfBookWithIndex:indexPath.row];
    cell.issueDesLable.text = [self.viewModel desOfBookWithIndex:indexPath.row];
    cell.issuePriceLable.text = [self.viewModel priceOfBookWithIndex:indexPath.row];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.row == 0)
       return CGSizeMake(2  , 4);
    return CGSizeMake(1  , 2);
}

@end
