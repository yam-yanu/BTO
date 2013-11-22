//
//  SearchViewController.h
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MissionViewController.h"
#import "SSGentleAlertView.h"
#import "UserDefaultAcceess.h"

@interface SearchViewController : UIViewController<GMSMapViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) GMSMapView *mapView;



@end
