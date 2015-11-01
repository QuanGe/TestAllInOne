//
//  PMBookViewModel.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookViewModel.h"
#import "PMAPIManager.h"
#import "PMDBManager.h"
#import "PMIssueModel.h"
@interface PMBookViewModel()
@property (nonatomic,readwrite,strong) NSMutableArray* dataArray;
@end

@implementation PMBookViewModel

- (RACSignal*)fetchBookStoreList
{
    if(!self.dataArray)
        self.dataArray = [NSMutableArray array];
    @weakify(self)
    return [[[PMAPIManager getInstance] fetchBookList] map:^id(id value) {
        @strongify(self)
        self.dataArray = value;
        
        return value;
    }] ;
}

- (RACSignal*)fetchLocalBookStoreList
{
    if(!self.dataArray)
        self.dataArray = [NSMutableArray array];
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.dataArray = [[PMDBManager getInstance] fetchAllBooks];
        [subscriber sendNext:self.dataArray];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }]  doError:^(NSError *error) {
        
    }];
}

- (RACSignal*)fetchMyBookList
{
    
   return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       self.dataArray = [[PMDBManager getInstance] fetchMylBooks];
       [subscriber sendNext:self.dataArray];
       [subscriber sendCompleted];
       return [RACDisposable disposableWithBlock:^{
           
       }];
   }]  doError:^(NSError *error) {
       
   }];
}

- (NSInteger)numOfBook
{
    return self.dataArray.count;
}

- (NSString *)titleOfBookWithIndex:(NSInteger)index
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    return mode.name;
}

- (NSString *)editionOfBookWithIndex:(NSInteger)index
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    return mode.edition;
}

- (NSString *)desOfBookWithIndex:(NSInteger)index
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    return mode.issueDescription;
}

- (NSString *)priceOfBookWithIndex:(NSInteger)index
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    return mode.price;
}

- (NSString *)imageUrlOfBookWithIndex:(NSInteger)index  big:(BOOL)big
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    return big ?mode.coverMedium2x:mode.coverSmall2x;
}

- (NSString *)issueIdOfBookWithIndex:(NSInteger)index
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    return mode.issueId;
}

- (NSString *)issueLocalUrlOfBookWithIndex:(NSInteger)index
{
    PMIssueModel *mode = [self.dataArray objectAtIndex:index];
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *issueIdMd5 = [mode.issueId qgocc_stringFromMD5];
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString * localUrl = [[NSString alloc] initWithString: [NSString stringWithFormat: @"%@/issues100/%@/me.magazine",docsDir,issueIdMd5]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    BOOL exist = [filemgr fileExistsAtPath:localUrl];
    
    return exist?localUrl:@"";
}

@end
