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
#import "PMImageCollectionFlowLayout.h"
#define kImageCollectionOffsetX ((mScreenWidth - 470)/2+20)
@interface PMHomeBaseViewController()
@property (nonatomic,readwrite,assign) NSInteger uiType;
@property (nonatomic,readwrite,strong) UIView * dataImageBox;
@property (nonatomic,readwrite,assign) CGPoint lastPoint;
@property (nonatomic,readwrite,strong) UILabel* curIssueTitleLabel;
@property (nonatomic,readwrite,strong) UILabel* curIssueEditionLable;
@property (nonatomic,readwrite,strong) UILabel* curIssuePriceLable;
@property (nonatomic,readwrite,strong) UILabel* pageNumAndIndeLabel;
@property (nonatomic,readwrite,assign) NSInteger curPageIndex;
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
    self.curPageIndex = 1;
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
        
        PMImageCollectionFlowLayout *recommentLayout=[[PMImageCollectionFlowLayout alloc] init];
        {
            [recommentLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            recommentLayout.headerReferenceSize = CGSizeMake(kImageCollectionOffsetX, 0);
            recommentLayout.footerReferenceSize = recommentLayout.headerReferenceSize;
            recommentLayout.itemSize = CGSizeMake(470  , 598);
            self.dataImageCollection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:recommentLayout];
            self.dataImageCollection.backgroundColor = [UIColor whiteColor];
            [self.dataImageCollection setDataSource:self];
            [self.dataImageCollection setDelegate:self];
            
            //self.dataImageCollection.pagingEnabled = YES;
            self.dataImageCollection.clipsToBounds = NO;
            //self.dataImageCollection.panGestureRecognizer.enabled = NO;
            [self.dataImageCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"dataImageCollectionCell"];
            [self.dataImageBox addSubview:self.dataImageCollection];
            [self.dataImageCollection mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(598);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(100);
            }];
            [RACObserve(self.dataImageCollection, contentOffset) subscribeNext:^(id x) {
                CGPoint contentOffset ;
                [x getValue:&contentOffset];
                if(contentOffset.x<0)
                    return ;
                if(contentOffset.x>[self.viewModel numOfBook]*recommentLayout.itemSize.width)
                    return;
                self.curPageIndex = contentOffset.x/recommentLayout.itemSize.width+1;
                if([self.viewModel numOfBook]>0)
                {
                    self.pageNumAndIndeLabel.text = [NSString stringWithFormat:@"%@ of %@",@(self.curPageIndex).stringValue,@([self.viewModel numOfBook]).stringValue];
                    self.curIssueTitleLabel.text = [self.viewModel titleOfBookWithIndex:self.curPageIndex-1];
                    self.curIssueEditionLable.text = [self.viewModel editionOfBookWithIndex:self.curPageIndex-1];
                    {
                        NSString * price = [self.viewModel priceOfBookWithIndex:self.curPageIndex-1] ;
                        NSMutableAttributedString * priceFront = [[NSMutableAttributedString alloc] initWithString:@"¥ " attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                                                                      NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                        NSAttributedString * priceA = [[NSAttributedString alloc] initWithString:price attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                        
                        [priceFront appendAttributedString:priceA];
                        
                        if(price.integerValue == 0)
                            self.curIssuePriceLable.attributedText = [[NSAttributedString alloc] initWithString:@"免费" attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                                                                                                                                   NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                        else
                            self.curIssuePriceLable.attributedText = priceFront;
                    }
                }

            }];
        }
        
        UIView * bottomView = [[UIView alloc] init];
        {
            
            bottomView.backgroundColor = [UIColor yellowColor];
            [self.dataImageBox addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.dataImageBox.mas_centerX);
                make.bottom.mas_equalTo(-50);
                make.height.mas_equalTo(180);
                make.width.mas_equalTo(mScreenWidth-2*kImageCollectionOffsetX);
            }];
            
            self.pageNumAndIndeLabel = [[UILabel alloc] init];
            {
                self.pageNumAndIndeLabel.textColor = [UIColor grayColor];
                self.pageNumAndIndeLabel.font = [UIFont systemFontOfSize:12];
                self.pageNumAndIndeLabel.textAlignment = NSTextAlignmentCenter;
                [bottomView addSubview:self.pageNumAndIndeLabel];
                [self.pageNumAndIndeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(20);
                    make.right.mas_equalTo(0);
                }];

            }
            
            self.curIssueTitleLabel = [[UILabel alloc] init];
            {
                self.curIssueTitleLabel.textColor = kBlackColor;
                self.curIssueTitleLabel.font = [UIFont boldSystemFontOfSize:13];
                //self.curIssueTitleLabel.textAlignment = NSTextAlignmentCenter;
                [bottomView addSubview:self.curIssueTitleLabel];
                [self.curIssueTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                    make.height.mas_equalTo(20);
                    make.right.mas_equalTo(0);
                }];
                
            }
            
            self.curIssueEditionLable = [[UILabel alloc] init];
            {
                self.curIssueEditionLable.textColor = [UIColor grayColor];
                
                self.curIssueEditionLable.font = [UIFont boldSystemFontOfSize:13];
                //self.curIssueTitleLabel.textAlignment = NSTextAlignmentCenter;
                [bottomView addSubview:self.curIssueEditionLable];
                [self.curIssueEditionLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.equalTo(self.curIssueTitleLabel.mas_bottom).offset(10);
                    make.height.mas_equalTo(20);
                    make.right.mas_equalTo(0);
                }];
                
            }
            
            self.curIssuePriceLable = [[UILabel alloc] init];
            {
                self.curIssuePriceLable.textColor = kBlackColor;
                self.curIssuePriceLable.font = [UIFont boldSystemFontOfSize:13];
                //self.curIssueTitleLabel.textAlignment = NSTextAlignmentCenter;
                [bottomView addSubview:self.curIssuePriceLable];
                [self.curIssuePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.equalTo(self.curIssueEditionLable.mas_bottom).offset(10);
                    make.height.mas_equalTo(20);
                    make.right.mas_equalTo(0);
                }];
                
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
    if([self.viewModel numOfBook]>0)
    {
        self.pageNumAndIndeLabel.text = [NSString stringWithFormat:@"%@ of %@",@(self.curPageIndex).stringValue,@([self.viewModel numOfBook]).stringValue];
        self.curIssueTitleLabel.text = [self.viewModel titleOfBookWithIndex:self.curPageIndex-1];
        self.curIssueEditionLable.text = [self.viewModel editionOfBookWithIndex:self.curPageIndex-1];
        {
            NSString * price = [self.viewModel priceOfBookWithIndex:self.curPageIndex] ;
            NSMutableAttributedString * priceFront = [[NSMutableAttributedString alloc] initWithString:@"¥ " attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            NSAttributedString * priceA = [[NSAttributedString alloc] initWithString:price attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            
            [priceFront appendAttributedString:priceA];
            
            if(price.integerValue == 0)
                self.curIssuePriceLable.attributedText = [[NSAttributedString alloc] initWithString:@"免费" attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            else
                self.curIssuePriceLable.attributedText = priceFront;
        }
    }

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
        if(price.integerValue == 0)
        {
            cell.downBtnType = PMBookCollectionViewCellBtnTypeDwonload;
        }
        else
            cell.downBtnType = PMBookCollectionViewCellBtnTypeBuy;
        if(![[self.viewModel issueLocalUrlOfBookWithIndex:indexPath.row] isEqualToString:@""])
        {
            
            cell.downBtnType = PMBookCollectionViewCellBtnTypeRead;
        }
        
        cell.downReadBuyBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
            switch (cell.downBtnType) {
                case PMBookCollectionViewCellBtnTypeDwonload:
                {
                    mAlertView(@"杂志", @"去下载啦");
                }
                    break;
                case PMBookCollectionViewCellBtnTypeBuy:
                {
                    mAlertView(@"杂志", @"去购买啦");
                }
                    break;
                case PMBookCollectionViewCellBtnTypeRead:
                {
                     mAlertView(@"杂志", @"打开杂志");
                }
                    break;
                    
                default:
                    break;
            }
            
            return [RACSignal empty];
        }];
        
        
        
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
