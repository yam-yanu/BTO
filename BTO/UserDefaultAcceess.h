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

@interface UserDefaultAcceess : NSObject

+ (id)LaunchApp;
+ (int)getMyID;
+ (void)RegisterMyPicture:(NSData *)picture;
+ (void)RegisterMyName:(NSString *)name;
+ (void)RegisterMyFeature:(NSString *)feature;
+ (void)RegisterMyGreeting:(NSString *)greeting;
+ (void)RegisterMyPassword:(NSString *)password;
+ (NSString *)getMyName;
+ (NSString *)getMyFeature;
+ (NSString *)getMyGreeting;
+ (NSString *)getMyPassword;
+ (NSData *)getMyPicture;
+ (void)RegisterBTOid:(int)BTOid;
+ (int)getBTOid;
+ (void)ChangeState:(int)state;
+ (int)getState;
+ (void)ChangeButtonState:(int)state;
+ (int)getButtonState;

@end
