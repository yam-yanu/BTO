//
//  DataBaseAccess.h
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "R9HTTPRequest.h"

@interface DataBaseAccess : NSObject
@property (copy, nonatomic) NSMutableArray *array;

-(NSMutableArray *) PicLocation;

@end
