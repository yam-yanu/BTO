//
//  RootViewController.h
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SSGentleAlertView.h"
#import "R9HTTPRequest.h"

@interface RootViewController : UIViewController<GMSMapViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) GMSMapView *mapView;

@end
