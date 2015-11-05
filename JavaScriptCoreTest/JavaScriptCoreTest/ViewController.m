//
//  ViewController.m
//  JavaScriptCoreTest
//
//  Created by 张如泉 on 15/11/4.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle]pathForResource:@"prettify"ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    UIWebView * web = [[UIWebView alloc] init];
    JSContext *context = [web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:testScript];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error: %@", exception);
    };
    JSValue *function = context[@"prettyPrintOne"];
    JSValue *result = [function callWithArguments:@[@"main \n{\n printf(); \n}",@"cpp",@(1)]];
    //JSValue *result = [context evaluateScript:@"prettyPrintOne('main','cpp',1)"];
    NSLog(@"factorial(10) = %@", [result toString]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
