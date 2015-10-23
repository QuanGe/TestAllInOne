//
//  PMBookViewModel.h
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "RVMViewModel.h"

@interface PMBookViewModel : RVMViewModel

- (RACSignal*)fetchBookStoreList;

- (RACSignal*)fetchLocalBookStoreList;

- (RACSignal*)fetchMyBookList;

- (NSInteger)numOfBook;

- (NSString *)titleOfBookWithIndex:(NSInteger)index;

- (NSString *)editionOfBookWithIndex:(NSInteger)index;

- (NSString *)desOfBookWithIndex:(NSInteger)index;

- (NSString *)priceOfBookWithIndex:(NSInteger)index;

- (NSString *)imageUrlOfBookWithIndex:(NSInteger)index;

- (NSString *)issueIdOfBookWithIndex:(NSInteger)index;
@end
