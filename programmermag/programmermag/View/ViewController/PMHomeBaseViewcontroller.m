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
#import "UIKit+AFNetworking.h"
@interface PMHomeBaseViewController()
@property (nonatomic,readwrite,assign) NSInteger uiType;
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
            
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(60);
        }];
    }

    self.viewModel = [[PMBookViewModel alloc] init];
    
    UIPageControl * page = [[UIPageControl alloc] init];
    {
       
        page.pageIndicatorTintColor = mRGBColor(180, 180, 180);
        page.currentPageIndicatorTintColor = mRGBColor(220, 220, 220);
        [self.view addSubview:page];
        [page mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-70);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        [RACObserve(self.dataView, contentSize) subscribeNext:^(id x) {
            CGSize size ;
            [x getValue:&size];
            page.numberOfPages = size.width/mScreenWidth;
        }];
        
        [RACObserve(self.dataView, contentOffset) subscribeNext:^(id x) {
            CGPoint p ;
            [x getValue:&p];
            page.currentPage = p.x /mScreenWidth;
        }];
        
    }
}

- (void)changeUIType:(NSInteger)type
{
    self.uiType = type;
    [self.dataView reloadData];
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
    NSString * price = [self.viewModel priceOfBookWithIndex:indexPath.row] ;
    NSMutableAttributedString * priceFront = [[NSMutableAttributedString alloc] initWithString:@"¥ " attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                             NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    NSAttributedString * priceA = [[NSAttributedString alloc] initWithString:price attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                                                                                                   NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    [priceFront appendAttributedString:priceA];
    
    if(price.integerValue == 0)
        cell.issuePriceLable.attributedText = [[NSAttributedString alloc] initWithString:@"免费" attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                                                                                                            NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    else
        cell.issuePriceLable.attributedText = priceFront;
    
    [cell.issueImageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[self.viewModel imageUrlOfBookWithIndex:indexPath.row]] placeholderImage:[UIImage qgocc_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(indexPath.row == 0 ?kBigImageWidth:kSmallImageWidth, indexPath.row == 0 ?400:200)]];
    
    if(indexPath.row == 0 &&self.uiType ==1)
        [cell changeBig:YES];
    else
        [cell changeBig:NO];
    
    if(indexPath.row == 2 || indexPath.row == 4)
        [cell changeDownBtnType:1];
    else
        [cell changeDownBtnType:0];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.row == 0 &&self.uiType ==1)
       return CGSizeMake(2  , 4.0);
    return CGSizeMake(1  , 2.0);
}

@end
