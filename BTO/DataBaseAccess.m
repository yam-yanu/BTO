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
@synthesize MyID;
@synthesize SuccessCheck;
@synthesize FailedCount;


//-------------------------------------SearchViewController-------------------------------------

//BTO全員の位置情報を取得し、マーカーを表示
-(void) PicLocation:(GMSMapView *)mapView View:(id)view{
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
        
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            [DataBaseAccess FailedInfomation];
        }else{
            FailedCount ++;
            [self PicLocation:mapView View:view];
        }
    }];
    [request startRequest];
    
}

//BTO一人の情報をダイアログで表示
-(void) DetailBTO :(int)BTOid View:(id)view{
    
    isFinished = NO;
    [SVProgressHUD show];
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = view;
    
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
            //写真があるときとないときでダイアログを変更する
            if(! ([NSString stringWithFormat:@"%@",[obj objectForKey:@"picture"]] == nil || [[NSString stringWithFormat:@"%@",[obj objectForKey:@"picture"]] isEqualToString:@""])){
                alert.message = [NSString stringWithFormat:@"\n\n\n\n\n特徴：%@\n一言：%@\n",[obj objectForKey:@"feature"],[obj objectForKey:@"greeting"]];
                NSData *nsData = [NSData dataWithBase64String:[NSString stringWithFormat:@"%@",[obj objectForKey:@"picture"]]];
                UIImageView *backImage = [[UIImageView alloc] init];
                backImage.frame = CGRectMake(115, 155, 90, 90);
                backImage.image = [UIImage imageWithData:nsData];
                [alert addSubview:backImage];
            }else{
                alert.message = [NSString stringWithFormat:@"特徴：%@\n一言：%@\n",[obj objectForKey:@"feature"],[obj objectForKey:@"greeting"]];
            }
        }
        if([UserDefaultAcceess getState] == 0){
            [alert addButtonWithTitle:@"やめとく"];
            [alert addButtonWithTitle:@"この人を捜す"];
        }else{
            [alert addButtonWithTitle:@"OK"];
        }
        alert.cancelButtonIndex = 0;
        [alert show];
        
        isFinished = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        [DataBaseAccess FailedAlert:view];
        isFinished = YES;
    }];
    [request startRequest];

    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    [SVProgressHUD dismiss];

}

//探している人数を増やす
-(void)AddSearcher:(int)BTOid{
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/AddSearcher.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            [DataBaseAccess FailedInfomation];
        }else{
            FailedCount ++;
            [self AddSearcher:BTOid];
        }
    }];
    [request startRequest];
}


//-------------------------------------MissionViewController-------------------------------------

//BTO一人の過去から現在までの現在地を取得し、マーカーを表示
//対象のBTOが離脱した場合、アラートで知らせて前の画面に戻る
-(void) PicAllLocation:(int)BTOid Map:(GMSMapView *)mapView View:(id)view SituationCheck:(BOOL)sc{
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/BetweenPandNLocation.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        // stringの中身がfailedだった場合、アラートで知らせる
        if([responseString isEqualToString:@"failed"]) {
            SSGentleAlertView* alert = [SSGentleAlertView new];
            alert.delegate = view;
            //現在自分がsearch側かBTO側かでメッセージを変える
            if([UserDefaultAcceess getState] == 1){
                alert.title = @"選択したBTOがいません";
                alert.message = @"選択していたBTOは\n現在リタイアしているようです。\n前の画面に戻ります。";
                [UserDefaultAcceess ChangeButtonState:10];
            }else if([UserDefaultAcceess getState] == 2){
                alert.title = @"あなたは現在リタイアしています";
                alert.message = @"何らかの理由であなたの位置情報が一定時間更新されなかったため、リタイアになってしまいました。";
            }
            [alert addButtonWithTitle:@"OK"];
            alert.cancelButtonIndex = 0;
            [alert show];
        }else{
            // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
            NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
            
            // JSON を NSArray に変換する
            NSError *error;
            NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            //マップの初期化（マーカーやラインなど）
            [mapView clear];
            GMSMutablePath *path = [GMSMutablePath path];
            for (NSDictionary *obj in array)
            {
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([(NSNumber *)[obj objectForKey:@"latitude"] doubleValue], [(NSNumber *)[obj objectForKey:@"longitude"] doubleValue]);
                marker.title = [obj objectForKey:@"date"];
                marker.map = mapView;
                marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0.0 green:[(NSNumber *)[obj objectForKey:@"depth"] doubleValue] blue:0.0 alpha:1.0]];
                [path addCoordinate:CLLocationCoordinate2DMake([(NSNumber *)[obj objectForKey:@"latitude"] doubleValue], [(NSNumber *)[obj objectForKey:@"longitude"] doubleValue])];
                //定期実行以外でこのメソッドが呼ばれた場合は地図の中心を変更
                if(sc){
                    GMSCameraPosition *NewLocation = [GMSCameraPosition cameraWithLatitude:[(NSNumber *)[obj objectForKey:@"latitude"] doubleValue] longitude:[(NSNumber *)[obj objectForKey:@"longitude"] doubleValue] zoom:15];
                    [mapView setCamera:NewLocation];
                }
            }
            GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
            rectangle.strokeWidth = 6;
            rectangle.strokeColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.8];
            rectangle.map = mapView;
        }
        
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            [DataBaseAccess FailedInfomation];
        }else{
            FailedCount ++;
            [self PicAllLocation:BTOid Map:mapView View:view SituationCheck:sc];
        }
    }];
    [request startRequest];
}

//探している人数、見つけた人数を取得し、表示
-(void) PicSearcherAndDiscover:(int)BTOid View:(UIView *)view{
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/PicSearcherAndDiscover.php"];
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
            UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-235),([[UIScreen mainScreen] bounds].size.height-60), 250, 200)];
            label.numberOfLines = 2;
            label.text = [NSString stringWithFormat:@"このおっさんを見つけた人:%d人\nこのおっさんを探している人:%d人",[(NSNumber *)[obj objectForKey:@"discover"] intValue],[(NSNumber *)[obj objectForKey:@"searcher"] intValue]];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            [[label layer] setCornerRadius:7.0];
            [label setClipsToBounds:YES];
            [label sizeToFit];
            [view addSubview:label];
        }
        
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
        }else{
            FailedCount ++;
            [self PicSearcherAndDiscover:BTOid View:view];
        }
    }];
    [request startRequest];
    
}

//探している人数を減らす
-(void)RemoveSearcher:(int)BTOid{
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/RemoveSearcher.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            [DataBaseAccess FailedInfomation];
        }else{
            FailedCount ++;
            [self RemoveSearcher:BTOid];
        }
    }];
    [request startRequest];
}

//見つけた人数を増やす
-(BOOL)AddDiscover:(int)myID BTOid:(int)BTOid PassWord:(NSString *)password View:(id)view{
    [SVProgressHUD show];
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/AddDiscover.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", myID] forKey:@"MyID"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request addBody:[NSString stringWithFormat:@"%@", password] forKey:@"password"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        // JSON を NSArray に変換する
        NSError *error;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        SuccessCheck = NO;
        //パスワード認証に成功していた場合と失敗していた場合で分ける
        for (NSDictionary *obj in array)
        {
            if([(NSString *)[obj objectForKey:@"result"] isEqualToString:@"true"]){
                SuccessCheck = YES;
            }else{
                SuccessCheck = NO;
            }
        }
        isFinished = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        [DataBaseAccess FailedAlert:view];
        isFinished = YES;
        SuccessCheck = NO;
    }];
    [request startRequest];
    
    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    [SVProgressHUD dismiss];
    return SuccessCheck;
}

//-------------------------------------RootViewController-------------------------------------

//ユーザーを登録
-(int) RegisterUser{
    
    isFinished = NO;
    MyID = 0;
    
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
        for (NSDictionary *obj in array)
        {
            MyID = [(NSNumber *)[obj objectForKey:@"id"] intValue];
        }
        
        //MyIDになにも入ってなかったら
        if(MyID == 0){
            if(FailedCount >= 3){
                FailedCount = 0;
            }else{
                FailedCount ++;
                [self RegisterUser];
            }
        }else{
            isFinished = YES;
            FailedCount = 0;
        }
        

    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            isFinished = YES;
        }else{
            FailedCount ++;
            [self RegisterUser];
        }
    }];
    
    [request startRequest];
    
    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    return MyID;
}


//-------------------------------------MakeBTOViewController-------------------------------------

//新しくBTOを始めるときに名前や特徴を更新
-(BOOL) UpdateBTO:(id)view BTOid:(int)BTOid Name:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting Password:(NSString *)password{
    isFinished = NO;
    [SVProgressHUD show];
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/UpdateBTO.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request addBody:name forKey:@"name"];
    [request addBody:feature forKey:@"feature"];
    [request addBody:greeting forKey:@"greeting"];
    [request addBody:password forKey:@"password"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%@",responseString);
        isFinished = YES;
        SuccessCheck = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        [DataBaseAccess FailedAlert:view];
        isFinished = YES;
        SuccessCheck = NO;
    }];
    [request startRequest];
    
    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    [SVProgressHUD dismiss];
    return SuccessCheck;
}

//新しくBTOを始めるときに非同期で写真をアップロード
-(void) UploadPicture:(int)BTOid Picture:(NSData *)picture{
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/UploadPicture.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request addBody:[picture base64String] forKey:@"picture"];
    //NSLog(@"%@",[picture base64String]);
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            [DataBaseAccess FailedInfomation];
        }else{
            FailedCount ++;
            [self UploadPicture:BTOid Picture:picture];
        }
    }];
    [request startRequest];
}

//-------------------------------------MissionForBTOViewController-------------------------------------

//BTOの位置情報が更新されたときにデータベースに登録
-(void) InsertDetailLocation:(int)BTOid Latitude:(double)latitude Longitude:(double)longitude View:(id)view{
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/InsertDetailLocation.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request addBody:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    [request addBody:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];

    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        FailedCount = 0;
    }];
    [request setFailedHandler:^(NSError *error){
        if(FailedCount >= 3){
            FailedCount = 0;
            [DataBaseAccess FailedInfomation];
        }else{
            FailedCount ++;
            [self InsertDetailLocation:BTOid Latitude:latitude Longitude:longitude View:view];
        }
    }];
    [request startRequest];
}

//BTOをやめるときにPROMOTEを０にする
-(BOOL) StopBTO:(int)BTOid View:(id)view{
    [SVProgressHUD show];
    isFinished = NO;
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/StopBTO.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:[NSString stringWithFormat:@"%d", BTOid] forKey:@"BTOid"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%@",responseString);
        isFinished = YES;
        SuccessCheck = YES;
    }];
    [request setFailedHandler:^(NSError *error){
        [DataBaseAccess FailedAlert:view];
        isFinished = YES;
        SuccessCheck = NO;
    }];
    [request startRequest];
    
    //通信処理が終了するまで待つ
    while (!isFinished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    [SVProgressHUD dismiss];
    return SuccessCheck;
}

+(void)FailedInfomation{
    [SVProgressHUD showErrorWithStatus:@"通信に失敗しました\n電波を確認してみてください"];
}

+(void)FailedAlert:(id)view{
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = view;
    alert.title = @"通信エラー";
    alert.message = @"何かおかしいようです\n少し時間をおいてみてください";
    [alert addButtonWithTitle:@"OK"];
    alert.cancelButtonIndex = 0;
    [alert show];
}
@end
