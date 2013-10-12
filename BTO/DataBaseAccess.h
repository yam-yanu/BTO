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
#import "UserDefaultAcceess.h"
#import "Base64.h"


@interface DataBaseAccess : NSObject<GMSMapViewDelegate>

@property (nonatomic)BOOL isFinished;
@property (nonatomic)BOOL MyID;
@property (nonatomic)int FailedCount;


-(void) PicLocation:(GMSMapView *)mapView View:(id)view;
-(void) DetailBTO:(int)BTOid View:(id)view;
-(void)AddSearcher:(int)BTOid View:(id)view;
-(void) PicAllLocation:(int)BTOid Map:(GMSMapView *)mapView View:(id)view SituationCheck:(BOOL)sc;
-(void)RemoveSearcher:(int)BTOid View:(id)view;
-(void)AddDiscover:(int)MyID BTOid:(int)BTOid;
-(int) RegisterUser;
-(void) UpdateBTO:(id)view BTOid:(int)BTOid Name:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting;
-(void) UploadPicture:(int)BTOid Picture:(NSData *)picture View:(id)view;
-(void) InsertDetailLocation:(int)BTOid Latitude:(double)latitude Longitude:(double)longitude View:(id)view;
-(void) StopBTO:(int)BTOid;
-(void) FailedDialog:(id)view;

@end
