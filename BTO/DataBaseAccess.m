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

    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/allBTO.php"];
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
    [request setFailedHandler:^(NSError *error){
        NSLog(@"失敗しました");
    }];
    [request startRequest];
}

-(NSMutableArray *) DetailBTO :(int)BTOid alert:(SSGentleAlertView *)alert{
    
    detailBTO = [NSMutableArray array];
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/detailBTO.php"];
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

//        detailBTO = [NSMutableArray array];
//        [detailBTO insertObject:@"2回目" atIndex:0];
//        [detailBTO insertObject:@"いけてるかな？" atIndex:1];
//        
//        alert.title = [detailBTO objectAtIndex:0];
//        alert.message = [detailBTO objectAtIndex:1];

        
        for (NSDictionary *obj in detailBTO)
        {
            alert.title = [NSString stringWithFormat:@"%@さんの情報",[obj objectForKey:@"name"]];
            alert.message = [NSString stringWithFormat:@"特徴：%@\n一言：%@\n",[obj objectForKey:@"feature"],[obj objectForKey:@"greeting"]];
        }
        [alert addButtonWithTitle:@"やめとく"];
        [alert addButtonWithTitle:@"この人を捜す"];
        alert.cancelButtonIndex = 0;
        [alert show];
        
        isFinished = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        alert.title = @"通信エラー";
        alert.message = @"何かおかしいようです\n少し時間をおいてみてください";
        [alert addButtonWithTitle:@"OK"];
        alert.cancelButtonIndex = 0;
        [alert show];
        
        isFinished = YES;
    }];
    [request startRequest];

    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    return detailBTO;
}

@end
