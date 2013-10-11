//
//  AppDelegate.h
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "RootViewController.h"
#import "UserDefaultAcceess.h"
#import "IIViewDeckController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *leftslideMenuController;


- (IIViewDeckController*)generateControllerStack;


@end
