//
//  DataBaseAccess.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "DataBaseAccess.h"

@implementation DataBaseAccess
@synthesize isFinished;
@synthesize detailBTO;


+(void) PicLocation:(GMSMapView *)mapView{

    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/hello.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        //NSLog(@"%@", responseString);
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        
        // JSON を NSArray に変換する
        NSError *error;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        for (NSDictionary *obj in array)
        {
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([(NSNumber *)[obj objectForKey:@"latitude"] floatValue], [(NSNumber *)[obj objectForKey:@"longitude"] floatValue]);
            marker.title = [obj objectForKey:@"id"];
            marker.snippet = [obj objectForKey:@"content"];
            marker.map = mapView;
        }
    }];
    [request startRequest];
}

-(NSMutableArray *) DetailBTO :(int)BTOid{
    
    detailBTO = [NSMutableArray array];
    [detailBTO insertObject:@"1回目" atIndex:0];
    [detailBTO insertObject:@"いけてるかな？" atIndex:1];
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/hello.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        //NSLog(@"%@", responseString);
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        
        // JSON を NSArray に変換する
        NSError *error;
        detailBTO = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];

        detailBTO = [NSMutableArray array];
        [detailBTO insertObject:@"2回目" atIndex:0];
        [detailBTO insertObject:@"いけてるかな？" atIndex:1];
        isFinished = YES;
        NSLog(@"終わった");
    }];
    [request startRequest];
    
    for(int i = 0; i< 5;i++){
        sleep(1);
        NSLog(@"%@",[detailBTO objectAtIndex:0]);
        if(isFinished == YES){
            NSLog(@"回ってる");
            break;
        }
    }
    return detailBTO;
}

@end
