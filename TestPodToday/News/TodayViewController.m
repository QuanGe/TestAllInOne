//
//  TodayViewController.m
//  News
//
//  Created by zhangruquan on 14/12/12.
//  Copyright (c) 2014年 net.csdn. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AFNetworking.h"
#import "UALogger.h"
@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
