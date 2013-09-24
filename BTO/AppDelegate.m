//
//  AppDelegate.m
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MissionViewController.h"
#import "MainViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyDiH_9H7-GylvuCQg5dqzcC1ELqg-7PHio"];
    
    // メインウインドウ
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // フレームをデバイスのスクリーンサイズにセット
    self.window.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-20);
    
    //メインビューコントローラ生成
    _mainViewController = [[MainViewController alloc] init];
    //メインウインドウのmainViewControllerをセット
    self.window.rootViewController = _mainViewController;
    
    
    // ルートビューコントローラを生成
    _rootViewController = [[RootViewController alloc] init];
    [self.window addSubview:_rootViewController.view];

    
//    //タブビューコントローラーを生成
//    _TabViewController = [[UITabBarController alloc] init];
//    
//    //タブビューを生成
//    MissionViewController* tab1 = [[MissionViewController alloc] init];
//    UIViewController* tab2 = [[UIViewController alloc] init];
//    
//    //作ったViewControllerをControllerにまとめて追加
//    NSArray* controllers = [NSArray arrayWithObjects:tab1,tab2,nil];
//    [(UITabBarController*)_TabViewController setViewControllers:controllers animated:NO];
//    
//    //windowにControllerのViewに追加
//    [self.window addSubview:_TabViewController.view];
    
    
    //ミッションビューコントローラを生成、サブビューとしてセット
    _missionViewController = [[MissionViewController alloc] init];
    [_window addSubview:_missionViewController.view];
    
    //rootViewを最前面に出す
    [_window bringSubviewToFront:_rootViewController.view];

    // レンダリング
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
