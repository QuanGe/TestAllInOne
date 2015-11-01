//
//  PMBookDetailViewController.m
//  programmermag
//
//  Created by 张如泉 on 15/10/22.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookDetailViewController.h"

@implementation PMBookDetailViewController

- (void)loadView
{
    [super loadView];
    [RACObserve(self, bookLocalUrl) subscribeNext:^(id x) {
        
        NSString* text = [NSString stringWithContentsOfFile:x encoding:NSUTF8StringEncoding error:NULL];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSData * resultDataChange = [[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters];
        resultDataChange = [resultDataChange qgocc_aes256_decrypt:kBookAESKey];
        text = [[NSString alloc ] initWithData:resultDataChange encoding:NSUTF8StringEncoding];
        NSLog(@"%@",text);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
@end
