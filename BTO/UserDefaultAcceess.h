//
//  UserDefaultAcceess.h
//  BTO
//
//  Created by ami on 2013/09/26.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseAccess.h"
#import "RootViewController.h"
#import "MissionViewController.h"
#import "MissionForBTOViewController.h"
#import "LeftSlideMenuViewController.h"

@interface UserDefaultAcceess : NSObject

+ (id)LaunchApp;
+ (int)getMyID;
+ (void)RegisterMyPicture:(NSData *)picture;
+ (void)RegisterMyStatus:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting;
+ (NSString *)getMyName;
+ (NSString *)getMyFeature;
+ (NSString *)getMyGreeting;
+ (NSData *)getMyPicture;
+ (void)RegisterBTOid:(int)BTOid;
+ (int)getBTOid;
+ (void)ChangeState:(int)state;

@end
