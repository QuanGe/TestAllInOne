//
//  PMAppDelegate.m
//  programmermag
//
//  Created by 张如泉 on 15/10/19.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMAppDelegate.h"

@interface PMAppDelegate ()

@end

@implementation PMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //底部选项卡设置
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabSelectColor,NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setItemWidth:30];
    [[UITabBar appearance] setBarTintColor:mRGBColor(30, 30, 30)];
    
    //导航条设置
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavTitleColor,
                                                           NSFontAttributeName:kNavTitleFont}];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    //[[UINavigationBar appearance] setTranslucent:YES];
    
    // 创建
    UITabBarController *homeTabBarController = [[UITabBarController alloc] init];
    {
        NSArray *titleArray = @[@"书店",@"我的书架"];
        NSArray *classArray = @[@"PMBookStoreViewController",@"PMMyBookViewController"];
        NSMutableArray *childControllers = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i = 0;i<2;i++)
        {
            UIViewController *childViewController = [[ objc_getClass(((NSString*)classArray[i]).UTF8String) alloc] init];
            childViewController.tabBarItem.title= titleArray[i];
            childViewController.view.backgroundColor = [UIColor whiteColor];
            childViewController.automaticallyAdjustsScrollViewInsets = NO;
            childViewController.tabBarItem.image=[[[UIImage imageNamed:(i==0?@"store":@"library")] qgocc_imageMaskedWithColor:kWhiteColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            childViewController.tabBarItem.selectedImage=[ [[UIImage imageNamed:(i==0?@"store":@"library")] qgocc_imageMaskedWithColor:kTabSelectColor ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:childViewController];
            [childControllers addObject:navController];
        }
        homeTabBarController.viewControllers = childControllers;
        
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:homeTabBarController];
    self.navigationController.navigationBarHidden = YES;
    // Display the window
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
