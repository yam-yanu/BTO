//
//  DataBaseAccess.h
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "R9HTTPRequest.h"
#import "SSGentleAlertView.h"


@interface DataBaseAccess : NSObject<GMSMapViewDelegate>

@property (nonatomic)BOOL isFinished;

+(void) PicLocation:(GMSMapView *)mapView;
-(void) DetailBTO:(int)BTOid alert:(SSGentleAlertView *)alert;

@end
