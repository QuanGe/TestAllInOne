//
//  ViewController.m
//  JavaScriptCoreTest
//
//  Created by 张如泉 on 15/11/4.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSCTest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    //第一个简单的例子
    JSContext *context = [[JSContext alloc] init];
    JSValue *jsVal = [context evaluateScript:@"21+7"];
    int iVal = [jsVal toInt32];
    NSLog(@"JSValue: %@, int: %d", jsVal, iVal);
    */
    
    /*
     //下标值来操作对象
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var arr = [21, 7 , 'iderzheng.com'];"];
    JSValue *jsArr = context[@"arr"]; // Get array from JSContext
    
    NSLog(@"JS Array: %@; Length: %@", jsArr, jsArr[@"length"]);
    jsArr[1] = @"blog"; // Use JSValue as array
    jsArr[7] = @7;
    
    NSLog(@"JS Array: %@; Length: %d", jsArr, [jsArr[@"length"] toInt32]);
    
    NSArray *nsArr = [jsArr toArray];
    NSLog(@"NSArray: %@", nsArr);*/
    
    /*
     //
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test"ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:testScript];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error: %@", exception);
    };
    JSValue *function = context[@"factorial"];
    JSValue *result = [function callWithArguments:@[@(10)]];
    NSLog(@"10的阶乘factorial(10) = %d", [result toInt32]);
     */
  
    /*
    //
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test"ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:testScript];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error: %@", exception);
    };
    JSValue *function = context[@"prettyPrintOne"];
    JSValue *result = [function callWithArguments:@[@"main \n{\n printf(); \n}",@"cpp",@(1)]];
    NSLog(@"代码转化结果 = %@", [result toString]);
    */
    
     //
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
    NSLog(@"高亮后的结果为 = %@", [result toString]);
    JSCTest *test = [[JSCTest alloc] init];
    NSLog(@"测试下标取值%@",test[0]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
