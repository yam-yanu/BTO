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
+ (void)RegisterMyID:(int)myid;
+ (void)RegisterBTOid;
+ (int)getBTOid;
+ (void)ChangeState:(int)state;


@end