//
//  PMBookDetailViewModel.h
//  programmermag
//
//  Created by 张如泉 on 15/11/2.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "RVMViewModel.h"
@class PMArticlePaperModel;
@interface PMBookDetailViewModel : RVMViewModel
- (instancetype)initWithBookLocalUrl:(NSString*)bookLocalUrl;
- (RACSignal*)fetchArticleList;
- (NSInteger)numOfArticle;
- (NSInteger)numOfPaperWithArticleIndex:(NSInteger)articleIndex;
- (void)addImageToPaperWithArticleIndex:(NSInteger)articleIndex;
- (PMArticlePaperModel*)paperWithPaperInde:(NSInteger)paperIndex articleIndex:(NSInteger)articleIndex;
@end
