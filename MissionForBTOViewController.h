//
//  MissionForBTOViewController.h
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "DataBaseAccess.h"
#import "UserDefaultAcceess.h"

@interface MissionForBTOViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, weak) GMSMapView *mapView;
@property (nonatomic, weak) NSTimer *tm;
@property (nonatomic, retain) CLLocationManager *locationManager;


@end
