//
//  ViewController.m
//  TestCurl
//
//  Created by 张汝泉 on 2017/10/5.
//  Copyright © 2017年 QuanGe. All rights reserved.
//

#import "ViewController.h"
#import "curl.h"

@interface ViewController ()
{
    CURL * _curl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _curl =  curl_easy_init();
    curl_easy_setopt(_curl, CURLOPT_URL,"https://500px.me/community/v2/user/graphic?imgsize=p2,p4&page=1&queriedUserId=de264db50460ca01a20e0c9b9387c6546&resourceType=3&size=20");
    curl_easy_setopt(_curl,CURLOPT_HTTPAUTH, CURLAUTH_ANY);
    curl_easy_setopt(_curl,CURLOPT_WRITEFUNCTION, urlCallbac);
    curl_easy_setopt(_curl,CURLOPT_WRITEFUNCTION, urlCallback);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA,self);
    CURLcode erroCode = curl_easy_perform(_curl);
    NSLog(@"end");
}

size_t urlCallbac(char *ptr,size_t size,size_t nmemeb,void *data) {
    const size_t sizeInBytes = size *nmemeb;
    ViewController *vc = (__bridge ViewController*)data;
    NSData * resultdata= [[NSData alloc] initWithBytes:ptr length:sizeInBytes];
    NSString *resultStr = [[NSString alloc] initWithData:resultdata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resultStr);
    
    return sizeInBytes;
}

size_t urlCallback(char *ptr,size_t size,size_t nmemeb,void *data) {
    const size_t sizeInBytes = size *nmemeb;
    ViewController *vc = (__bridge ViewController*)data;
    NSData * resultdata= [[NSData alloc] initWithBytes:ptr length:sizeInBytes];
    NSString *resultStr = [[NSString alloc] initWithData:resultdata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resultStr);
    
    return sizeInBytes;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
