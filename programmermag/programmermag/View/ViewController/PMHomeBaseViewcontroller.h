//
//  PMHomeBaseViewController.h
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBookViewModel.h"
#import "RFQuiltLayout.h"
@interface PMHomeBaseViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,RFQuiltLayoutDelegate>
@property (nonatomic,readwrite,strong) UICollectionView * dataView;
@property (nonatomic,readwrite,strong) PMBookViewModel * viewModel;
@property (nonatomic,readwrite,strong) UICollectionView * dataImageCollection;
- (void)changeUIType:(NSInteger)type;
@end
