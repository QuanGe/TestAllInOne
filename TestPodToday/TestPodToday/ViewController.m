//
//  ViewController.m
//  TestPodToday
//
//  Created by 张如泉 on 16/3/17.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UALogger.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                
                break;
            }
            default:
                break;
        }
        
        UALog(@"网络状态数字返回：%i", status);
        UALog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
