//
//  AppDelegate.h
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MainViewController.h"
#import "RootViewController.h"
#import "MissionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//    UIWindow* _window;
//    UIViewController* mainViewController;
//    UIViewController* rootViewController;
//    UIViewController* missionViewController;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) MissionViewController *missionViewController;
//@property (strong, nonatomic) UIViewController *TabViewController;


@end
