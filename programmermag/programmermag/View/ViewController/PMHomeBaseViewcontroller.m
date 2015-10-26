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
@property (nonatomic,readwrite,strong) UIView * dataImageBox;
@property (nonatomic,readwrite,assign) CGPoint lastPoint;
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
    
    self.dataImageBox = [[UIView alloc] init];
    {
        self.dataImageBox.hidden = YES;
        self.dataImageBox.backgroundColor = kWhiteColor;
        [self.view addSubview:self.dataImageBox ];
        
        UICollectionViewFlowLayout *recommentLayout=[[UICollectionViewFlowLayout alloc] init];
        {
            [recommentLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            recommentLayout.headerReferenceSize = CGSizeMake((mScreenWidth - 470)/2+20, 0);
            self.dataImageCollection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:recommentLayout];
            self.dataImageCollection.backgroundColor = [UIColor whiteColor];
            [self.dataImageCollection setDataSource:self];
            [self.dataImageCollection setDelegate:self];
            self.dataImageCollection.pagingEnabled = YES;
            self.dataImageCollection.clipsToBounds = NO;
            self.dataImageCollection.panGestureRecognizer.enabled = NO;
            [self.dataImageCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"dataImageCollectionCell"];
            [self.dataImageBox addSubview:self.dataImageCollection];
            [self.dataImageCollection mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(598);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(100);
            }];
            
            UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] init];
            {
                [panGesture.rac_gestureSignal subscribeNext:^(UIPanGestureRecognizer * recognizer) {
                    CGPoint point = [recognizer translationInView:self.dataImageCollection];
                    if(recognizer.state == UIGestureRecognizerStateBegan)
                        self.lastPoint = self.dataImageCollection.contentOffset;
                    self.dataImageCollection.contentOffset = CGPointMake(self.lastPoint.x-point.x, 0);
                    if (recognizer.state == UIGestureRecognizerStateEnded) {
                        NSLog(@"结束拖动");
                    }
                }];
                [self.dataImageCollection addGestureRecognizer:panGesture];
            }
        }
        
        [self.dataImageBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(60);
        }];
    }
}

- (void)changeUIType:(NSInteger)type
{
    self.uiType = type;
    self.dataImageBox.hidden = !(type==3);
    [self.dataView reloadData];
}

#pragma mark --UICollectionView回调
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numOfBook];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([cv isEqual:self.dataView])
    {
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
        
        [cell.issueImageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[self.viewModel imageUrlOfBookWithIndex:indexPath.row big:indexPath.row == 0]] placeholderImage:[UIImage qgocc_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(indexPath.row == 0 ?kBigImageWidth:kSmallImageWidth, indexPath.row == 0 ?400:200)]];
        
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
    else
    {
        UICollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:@"dataImageCollectionCell" forIndexPath:indexPath];
        cell.contentView.clipsToBounds = NO;
        if(cell.contentView.subviews.count == 0)
        {
            UIImageView * imageview = [[UIImageView alloc]init];
            {
                [cell.contentView addSubview:imageview];
                [imageview setImageWithURL:[NSURL URLWithString:[self.viewModel imageUrlOfBookWithIndex:indexPath.row big:YES]] placeholderImage:[UIImage qgocc_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(430,598)]];
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(-40);
                    make.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                }];
            }
            
        }
        else
        {
            UIImageView * image = (UIImageView *)cell.contentView.subviews.firstObject;
            if(image)
            [image setImageWithURL:[NSURL URLWithString:[self.viewModel imageUrlOfBookWithIndex:indexPath.row big:YES]] placeholderImage:[UIImage qgocc_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(430,598)]];

        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(470  , 598);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
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
