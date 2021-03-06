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


//-------------------------------------SearchViewController-------------------------------------

//BTO全員の位置情報を取得し、マーカーを表示
+(void) PicLocation:(GMSMapView *)mapView{

    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/allBTO.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
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
            marker.position = CLLocationCoordinate2DMake([(NSNumber *)[obj objectForKey:@"latitude"] doubleValue], [(NSNumber *)[obj objectForKey:@"longitude"] doubleValue]);
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

//BTO一人の情報をダイアログで表示
-(void) DetailBTO :(int)BTOid alert:(SSGentleAlertView *)alert{
    
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/detailBTO.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        
        // JSON を NSArray に変換する
        NSError *error;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];

        for (NSDictionary *obj in array)
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

}


//-------------------------------------MissionViewController-------------------------------------

//BTO一人の過去から現在までの現在地を取得し、マーカーを表示
//対象のBTOが離脱した場合、アラートで知らせて前の画面に戻る
+(void) PicAllLocation:(int)BTOid Map:(GMSMapView *)mapView View:(id)view{
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/BetweenPandNLocation.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        // stringの中身がfailedだった場合、アラートで知らせる
        if([responseString isEqualToString:@"failed"]) {
            SSGentleAlertView* alert = [SSGentleAlertView new];
            alert.delegate = view;
            alert.title = @"BTOおらんパターン";
            alert.message = @"やらかした！";
            [alert addButtonWithTitle:@"OK"];
            alert.cancelButtonIndex = 0;
            [alert show];
        }else{
            NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
            
            // JSON を NSArray に変換する
            NSError *error;
            NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            GMSMutablePath *path = [GMSMutablePath path];
            for (NSDictionary *obj in array)
            {
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([(NSNumber *)[obj objectForKey:@"latitude"] doubleValue], [(NSNumber *)[obj objectForKey:@"longitude"] doubleValue]);
                marker.title = [obj objectForKey:@"date"];
                marker.map = mapView;
                marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0.0 green:[(NSNumber *)[obj objectForKey:@"depth"] doubleValue] blue:0.0 alpha:1.0]];
                GMSCameraPosition *NewLocation = [GMSCameraPosition cameraWithLatitude:[(NSNumber *)[obj objectForKey:@"latitude"] doubleValue] longitude:[(NSNumber *)[obj objectForKey:@"longitude"] doubleValue] zoom:15];
                [mapView setCamera:NewLocation];
                [path addCoordinate:CLLocationCoordinate2DMake([(NSNumber *)[obj objectForKey:@"latitude"] doubleValue], [(NSNumber *)[obj objectForKey:@"longitude"] doubleValue])];
            }
            GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
            rectangle.strokeWidth = 6;
            rectangle.strokeColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.8];
            rectangle.map = mapView;
        }

    }];
    [request setFailedHandler:^(NSError *error){
        NSLog(@"失敗しました");
    }];
    [request startRequest];
}


//-------------------------------------RootViewController-------------------------------------

//ユーザーを登録
-(void) RegisterUser{
    
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/RegisterUser.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        
        // JSON を NSArray に変換する
        NSError *error;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        int id = 0;
        for (NSDictionary *obj in array)
        {
            id = [(NSNumber *)[obj objectForKey:@"id"] intValue];
        }
        if(id != 0){
            //ユーザーデフォルトに自分のIDを登録
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:id forKey:@"myID"];
        }else{
            //もう一度通信を開始
            [self RegisterUser];
        }
        
        isFinished = YES;

    }];
    [request setFailedHandler:^(NSError *error){
        //もう一度通信を開始
        [self RegisterUser];
        isFinished = YES;
    }];
    
    [request startRequest];
    
    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}


//-------------------------------------MakeBTOViewController-------------------------------------

//新しくBTOを始めるときに名前や特徴を更新+今までの位置情報を削除
-(void) UpdateBTO:(id)view BTOid:(int)BTOid Name:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting{
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/UpdateBTO.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request addBody:name forKey:@"name"];
    [request addBody:feature forKey:@"feature"];
    [request addBody:greeting forKey:@"greeting"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        isFinished = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        SSGentleAlertView* alert = [SSGentleAlertView new];
        alert.delegate = view;
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
}

//-------------------------------------MissionBTOViewController-------------------------------------

//BTOの位置情報が更新されたときにデータベースに登録
+(void) InsertDetailLocation:(int)BTOid Latitude:(double)latitude Longitude:(double)longitude{
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/InsertDetailLocation.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request addBody:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    [request addBody:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];

    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
    }];
    [request setFailedHandler:^(NSError *error){

    }];
    [request startRequest];
}

//BTOをやめるときにPROMOTEを０にする
-(void) StopBTO:(int)BTOid{
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/StopBTO.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        // JSON を NSArray に変換する
        NSError *error;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        int check = 1;
        for (NSDictionary *obj in array)
        {
            check = [(NSNumber *)[obj objectForKey:@"check"] intValue];
        }
        if(check != 0){
            //もう一度通信を開始
            [self StopBTO:BTOid];
        }
        
        isFinished = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        //もう一度通信を開始
        [self StopBTO:BTOid];
        
        isFinished = YES;
    }];
    [request startRequest];
}

@end
