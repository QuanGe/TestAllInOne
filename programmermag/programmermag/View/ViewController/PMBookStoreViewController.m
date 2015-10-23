//
//  PMBookStoreViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookStoreViewController.h"
#import "UIViewController+MBProgressHUD.h"
@interface PMBookStoreViewController ()
@property (nonatomic,readwrite,strong) UIActivityIndicatorView *refreshView;

@end

@implementation PMBookStoreViewController
- (void)loadView
{
    [super loadView];
    UIView * customBarButtonBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    {
        UIButton * changeUIBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 17, 17)];
        {
            [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, 0, 17*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina])] forState:UIControlStateNormal];
            [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, 16*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina])] forState:UIControlStateHighlighted];
            changeUIBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                changeUIBtn.tag = changeUIBtn.tag == 0?1:0;
                [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, changeUIBtn.tag == 0?0:32*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina])] forState:UIControlStateNormal];
                [changeUIBtn setImage:[[UIImage imageNamed:@"togglecovers"] qgocc_captureImageWithFrame:CGRectMake(0, changeUIBtn.tag == 0?17*[UIDevice qgocc_isRetina]:51*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina], 17*[UIDevice qgocc_isRetina])] forState:UIControlStateHighlighted];
                return [RACSignal empty];
            }];
            [customBarButtonBox addSubview:changeUIBtn];
        }
        
        UIButton * reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 10, 18, 18)];
        {
            [reloadBtn setImage:[[UIImage imageNamed:@"reload"] qgocc_captureImageWithFrame:CGRectMake(0, 0, 18*[UIDevice qgocc_isRetina], 18*[UIDevice qgocc_isRetina])] forState:UIControlStateNormal];
            [reloadBtn setImage:[[UIImage imageNamed:@"reload"] qgocc_captureImageWithFrame:CGRectMake(0, 18*[UIDevice qgocc_isRetina], 18*[UIDevice qgocc_isRetina], 18*[UIDevice qgocc_isRetina])] forState:UIControlStateHighlighted];
            reloadBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                [self.refreshView stopAnimating];
                [[self.viewModel fetchBookStoreList] subscribeNext:^(id x) {
                    [self.dataView reloadData];
                } error:^(NSError *error) {
                    [self.refreshView stopAnimating];
                    [self showLoadAlertView:NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil) imageName:nil autoHide:YES];
                }];
                return [RACSignal empty];
            }];
            [customBarButtonBox addSubview:reloadBtn];
        }
        
        self.refreshView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 0, 34, 34)];
        {
            [customBarButtonBox addSubview:self.refreshView];
            self.refreshView.color = kBlackColor;
            self.refreshView.hidesWhenStopped = YES;
            [RACObserve(self.refreshView, hidden) subscribeNext:^(id x) {
                reloadBtn.hidden = ![x boolValue];
            }];
            
            
        }
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonBox];
        [self.navigationItem setRightBarButtonItem:rightBtn];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.viewModel fetchLocalBookStoreList] subscribeNext:^(id x) {
        [self.dataView reloadData];
    }];
    
    [self.refreshView stopAnimating];
    [[self.viewModel fetchBookStoreList] subscribeNext:^(id x) {
        [self.dataView reloadData];
    } error:^(NSError *error) {
        [self.refreshView stopAnimating];
        [self showLoadAlertView:NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil) imageName:nil autoHide:YES];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


@end
