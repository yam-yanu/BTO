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


@interface DataBaseAccess : NSObject<GMSMapViewDelegate>

@property (nonatomic)BOOL isFinished;
@property (copy,nonatomic)NSMutableArray *detailBTO;

+(void) PicLocation:(GMSMapView *)mapView;
-(NSMutableArray *) DetailBTO:(int)BTOid;

@end
