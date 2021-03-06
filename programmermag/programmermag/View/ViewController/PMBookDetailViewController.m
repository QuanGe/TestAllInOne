//
//  PMBookDetailViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookDetailViewController.h"
#import "PMBookDetailViewModel.h"
#import "PMBookPaperCollectionViewCell.h"
@interface PMBookDetailViewController()
@property (nonatomic,readwrite,strong) PMBookDetailViewModel * viewModel;
@property (nonatomic,readwrite,strong) UICollectionView * dataImageCollection;
@property (nonatomic,readwrite,strong) UILabel* pageNumLabel;
@property (nonatomic,readwrite,strong) UIPageControl * page;
@end

@implementation PMBookDetailViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = kWhiteColor;
    [RACObserve(self, bookLocalUrl) subscribeNext:^(id x) {
        
       if(self.viewModel == nil)
           self.viewModel = [[PMBookDetailViewModel alloc] initWithBookLocalUrl:x];
           
        }];
    //self.navigationController.navigationBar.hidden  = YES;
    UIView * customBarButtonBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    //customBarButtonBox.backgroundColor = [UIColor blackColor];
    {
        UIButton * backBtn = [[UIButton alloc] init];
        backBtn.tag = 2222;
        [backBtn setImage:[[UIImage imageNamed:@"topbtn_exit"] qgocc_captureImageWithFrame:CGRectMake(0, 0, 48*[UIDevice qgocc_isRetina], 40*[UIDevice qgocc_isRetina])]  forState:UIControlStateNormal];
        [backBtn setImage:[[UIImage imageNamed:@"topbtn_exit"] qgocc_captureImageWithFrame:CGRectMake(0, 48*[UIDevice qgocc_isRetina], 48*[UIDevice qgocc_isRetina], 48*[UIDevice qgocc_isRetina])]  forState:UIControlStateHighlighted];
        
        [customBarButtonBox addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo( 40);
            make.width.mas_equalTo(48);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo((kLeftOrRightEdgeInset-48));
        }];
        @weakify(self)
        backBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            [self.navigationController popViewControllerAnimated:YES];
            return [RACSignal empty];
        }];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonBox];
        [self.navigationItem setLeftBarButtonItem:rightBtn];
       
        
        
    }
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tabBarController.qgocc_tabBarHidden = YES;

    
    
    UICollectionViewFlowLayout *recommentLayout=[[UICollectionViewFlowLayout alloc] init];
    {
        [recommentLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        recommentLayout.headerReferenceSize = CGSizeMake(0, 0);
        recommentLayout.footerReferenceSize = recommentLayout.headerReferenceSize;
    
        self.dataImageCollection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:recommentLayout];
        self.dataImageCollection.backgroundColor = [UIColor whiteColor];
        [self.dataImageCollection setDataSource:self];
        [self.dataImageCollection setDelegate:self];
        
        self.dataImageCollection.pagingEnabled = YES;
        self.dataImageCollection.clipsToBounds = NO;
        //self.dataImageCollection.panGestureRecognizer.enabled = NO;
        [self.dataImageCollection registerClass:[PMBookPaperCollectionViewCell class] forCellWithReuseIdentifier:@"PMBookPaperCollectionViewCell"];
        [self.view addSubview:self.dataImageCollection];
        [self.dataImageCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(20);
        }];
        
        
    }
    
    self.pageNumLabel = [[UILabel alloc] init];
    {
        [self.view addSubview:self.pageNumLabel];
        self.pageNumLabel.textAlignment = NSTextAlignmentRight;
        [self.pageNumLabel setTextColor:[UIColor grayColor]];
        [self.pageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-20);
            make.width.mas_equalTo(80);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(30);
        }];
        [RACObserve(self.dataImageCollection, contentSize) subscribeNext:^(id x) {
            CGSize size ;
            [x getValue:&size];
            self.pageNumLabel.tag = size.width/mScreenWidth;
        }];
        
        [RACObserve(self.dataImageCollection, contentOffset) subscribeNext:^(id x) {
            CGPoint p ;
            [x getValue:&p];
            self.pageNumLabel.text = [NSString stringWithFormat:@"%@/%@",@((NSInteger)(p.x /mScreenWidth)).stringValue,@((NSInteger)(self.pageNumLabel.tag)).stringValue];
        }];
    }
    
    self.page = [[UIPageControl alloc] init];
    {
        
        self.page.pageIndicatorTintColor = mRGBColor(180, 180, 180);
        self.page.currentPageIndicatorTintColor = mRGBColor(220, 220, 220);
        [self.view addSubview:self.page];
        [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-20);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
    }
    [[self.viewModel fetchArticleList] subscribeNext:^(id x) {
        [self.dataImageCollection reloadData];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return [self.viewModel numOfArticle];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.viewModel numOfPaperWithArticleIndex:section];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PMBookPaperCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PMBookPaperCollectionViewCell" forIndexPath:indexPath];
    cell.paperModel = [self.viewModel paperWithPaperInde:indexPath.row articleIndex:indexPath.section];
    if(indexPath.section<[self.viewModel numOfArticle]-1)
        [self.viewModel addImageToPaperWithArticleIndex:indexPath.section+1];
    self.pageNumLabel.hidden=indexPath.section==0;
    self.page.hidden=indexPath.section==0;
    self.page.numberOfPages = [self.viewModel numOfPaperWithArticleIndex:indexPath.section];

    self.page.currentPage = indexPath.row;
    
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(mScreenWidth  , mScreenHeight-20);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
@end
