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
#import "SVProgressHUD.h"


@interface DataBaseAccess : NSObject<GMSMapViewDelegate>

@property (nonatomic)BOOL isFinished;
@property (nonatomic)BOOL MyID;
@property (nonatomic)BOOL SuccessCheck;
@property (nonatomic)int FailedCount;


-(void) PicLocation:(GMSMapView *)mapView View:(id)view;
-(void) DetailBTO:(int)BTOid View:(id)view;
-(void)AddSearcher:(int)BTOid;
-(void) PicAllLocation:(int)BTOid Map:(GMSMapView *)mapView View:(id)view SituationCheck:(BOOL)sc;
-(void) PicSearcherAndDiscover:(int)BTOid View:(UIView *)view;
-(void)RemoveSearcher:(int)BTOid;
-(BOOL)AddDiscover:(int)myID BTOid:(int)BTOid PassWord:(NSString *)password View:(id)view;
-(int) RegisterUser;
-(BOOL) UpdateBTO:(id)view BTOid:(int)BTOid Name:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting Password:(NSString *)password;
-(void) UploadPicture:(int)BTOid Picture:(NSData *)picture;
-(void) InsertDetailLocation:(int)BTOid Latitude:(double)latitude Longitude:(double)longitude View:(id)view;
-(BOOL) StopBTO:(int)BTOid View:(id)view;
+(void) FailedInfomation;
+(void)FailedAlert:(id)view;

@end
