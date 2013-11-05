//
//  MissionViewController.h
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DataBaseAccess.h"
#import "UserDefaultAcceess.h"

@interface MissionViewController : UIViewController<UINavigationControllerDelegate,GMSMapViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak) GMSMapView *mapView;
@property (nonatomic, weak) NSTimer *tm;

//@property (strong, nonatomic) UIViewController *centerController;
//@property (strong, nonatomic) UIViewController *leftslideMenuController;


@end
