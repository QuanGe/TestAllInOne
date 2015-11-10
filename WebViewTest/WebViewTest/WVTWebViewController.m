//
//  WVTWebViewController.m
//  WebViewTest
//
//  Created by 张如泉 on 15/11/10.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "WVTWebViewController.h"

@interface WVTWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation WVTWebViewController
- (void)dealloc
{
    //[self.webView loadHTMLString:nil baseURL:nil];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.webview = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webview loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.csdn.net"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
