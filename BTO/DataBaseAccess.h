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
@property (nonatomic)BOOL MyID;

+(void) PicLocation:(GMSMapView *)mapView;
-(void) DetailBTO:(int)BTOid  View:(id)view;
+(void) PicAllLocation:(int)BTOid Map:(GMSMapView *)mapView View:(id)view SituationCheck:(BOOL)sc;
-(int) RegisterUser;
-(void) UpdateBTO:(id)view BTOid:(int)BTOid Name:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting;
+(void) InsertDetailLocation:(int)BTOid Latitude:(double)latitude Longitude:(double)longitude;
-(void) StopBTO:(int)BTOid;

@end
