//
//  UserDefaultAcceess.m
//  BTO
//
//  Created by ami on 2013/09/26.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "UserDefaultAcceess.h"

@implementation UserDefaultAcceess

//------------------------------最初に起動したときに使用---------------------------------------

+ (id)LaunchApp{
    //ユーザーデフォルトからMyIDを取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int MyID = [userDefaults integerForKey:@"MyID"];
    //初めてアプリを起動する場合IDを登録
    if(MyID == 0){
        DataBaseAccess *database = [[DataBaseAccess alloc]init];
        // ユーザーデフォルトにMyIDを登録+BTOid,Stateを初期化
        [userDefaults setInteger:[database RegisterUser] forKey:@"MyID"];
        [userDefaults setInteger:0 forKey:@"BTOid"];
        [userDefaults setInteger:0 forKey:@"State"];
    }
    
    //ユーザーデフォルトからStateを取得
    int State = [userDefaults integerForKey:@"State"];
    NSLog(@"stateの数値%d",State);

    //現在の状態から正しい画面に遷移する
    if(State == 1){//MissionViewに移動
        MissionViewController *missionViewController = [[MissionViewController alloc]init];
        NSLog(@"Mission");
        return missionViewController;
    }else if(State == 2){//MissionForViewに移動
        MissionForBTOViewController *missionForBTOViewController = [[MissionForBTOViewController alloc]init];
        return missionForBTOViewController;
    }else{//RootViewに移動
        RootViewController *rootViewController = [[RootViewController alloc]init];
        NSLog(@"root");
        return rootViewController;
    }
    
}

//-------------------------------BTO側で使用--------------------------------------------------

//MyIDを返す
+ (int)getMyID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"MyID"];
}

//自分の名前、特徴、一言を登録
+ (void)RegisterMyStatus:(NSString *)name Feature:(NSString *)feature Greeting:(NSString *)greeting{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"Name"];
    [userDefaults setObject:feature forKey:@"Feature"];
    [userDefaults setObject:greeting forKey:@"Greeting"];
}

//自分の名前を返す
+ (NSString *)getMyName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"Name"];
}

//自分の特徴を返す
+ (NSString *)getMyFeature{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"Feature"];
}

//自分の一言を返す
+ (NSString *)getMyGreeting{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"Greeting"];
}

//-------------------------------Searcher側で使用----------------------------------------------

//参照するBTOidを登録(おそらくSearchViewで使用)
+ (void)RegisterBTOid:(int)BTOid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:BTOid forKey:@"BTOid"];
}

//BTOidを返す(おそらくMissionViewで使用)
+ (int)getBTOid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"BTOid"];
}


//-------------------------------すべてのviewで使用--------------------------------------------

//現在の状態の変更を登録する
+ (void)ChangeState:(int)state{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:state forKey:@"State"];
}

@end

