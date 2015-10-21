//
//  PMIssueModel.h
//  programmermag
//
//  Created by 张如泉 on 15/10/21.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMIssueModel : NSObject
@property (nonatomic,readwrite,copy) NSString *name ;
@property (nonatomic,readwrite,copy) NSString *edition;
@property (nonatomic,readwrite,copy) NSString *issueDescription;
@property (nonatomic,readwrite,copy) NSString *special;
@property (nonatomic,readwrite,copy) NSString *issueId;
@property (nonatomic,readwrite,copy) NSString *price;
@property (nonatomic,readwrite,copy) NSString *package ;
@property (nonatomic,readwrite,copy) NSString *package2x;
@property (nonatomic,readwrite,copy) NSString *packageSize;
@property (nonatomic,readwrite,copy) NSString *packageSize2x;
@property (nonatomic,readwrite,copy) NSString *packageMD5;
@property (nonatomic,readwrite,copy) NSString *package2xMD5;
@property (nonatomic,readwrite,copy) NSString *packageUpdated;
@property (nonatomic,readwrite,copy) NSString *package2xUpdated;
@property (nonatomic,readwrite,copy) NSString *toc;
@property (nonatomic,readwrite,copy) NSString *coverSmall;
@property (nonatomic,readwrite,copy) NSString *coverSmall2x;
@property (nonatomic,readwrite,copy) NSString *coverMedium;
@property (nonatomic,readwrite,copy) NSString *coverMedium2x;
@property (nonatomic,readwrite,copy) NSString *coverLarge;
@property (nonatomic,readwrite,copy) NSString *coverLarge2x;
@property (nonatomic,readwrite,copy) NSString *datePublished;
@property (nonatomic,readwrite,copy) NSString *dateUpdated;
@end
