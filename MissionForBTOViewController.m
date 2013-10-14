//
//  MissionForBTOViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "MissionForBTOViewController.h"
#import "IIViewDeckController.h"
@interface MissionForBTOViewController ()

@end


//自分が表示されている場所の地図、探している人数、見つけられた数などを表示
@implementation MissionForBTOViewController
@synthesize mapView;
@synthesize tm;
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //----------------------------------View部分を書く(マップやfacebookライクなバーなど)---------------------------------------------------------
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38
                                                            longitude:136.5
                                                                 zoom:5];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.delegate = self;
    self.view = mapView;
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicAllLocation:[UserDefaultAcceess getMyID] Map:mapView View:self SituationCheck:YES];
    
    //探している人数、見つけた人数を表示
    [[[DataBaseAccess alloc]init] PicSearcherAndDiscover:[UserDefaultAcceess getBTOid] View:self.view];
    
    //rootViewに戻るボタン
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(10, 10, 30, 30);
    back.backgroundColor = [UIColor clearColor];
    [back setTitle:@"←" forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    //----------------------------------裏側の処理（ホームからの復帰時のマーカーの更新＋マーカーの定期更新)------------------------------------------
    //通知受信の設定(フォアグラウンドに戻ったとき＋バックグラウンド入ったときに使用)
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
    
    //定期的にマーカーの情報を更新(とりあえずは一分ごと)
    tm = [NSTimer
          scheduledTimerWithTimeInterval:60.0f
          target:self
          selector:@selector(IntervalAction:)
          userInfo:nil
          repeats:YES];
    
    //GPSサービスの開始
    [self StartLocationManager];
}

-(void)back:(UIButton*)button{
    //RootViewControllerに遷移
    UIViewController *root = [[RootViewController alloc]init];
    root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:root animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
    }];
}

// BTOが存在しなくなった時(自分が何らかの理由でBTOをリタイアした時)にアラートのボタンが表示され、ボタンが押された時に呼ばれる
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:^{
        [UserDefaultAcceess ChangeState:0];
    }];
    [self.viewDeckController closeLeftViewAnimated:YES];

}

//----------------------------------裏側の処理（ホームからの復帰時のマーカーの更新＋マーカーの定期更新)------------------------------------------

//他の画面に遷移するとマーカーの定期更新を終了＋位置情報取得を終了
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [tm invalidate];
    tm = nil;
}

//バックグラウンドに入るとマーカーの定期更新を終了＋バックグラウンド用の位置情報取得の定期実行を開始
- (void)applicationDidEnterBackground{
    [tm invalidate];
    tm = nil;
    [[UIApplication sharedApplication] setKeepAliveTimeout:600.0 handler:^{
        [self StartLocationManager];
    }];
}

//フォアグラウンドに戻ったときにマーカーを再描写＋バックグラウンド用の位置情報取得の定期実行を終了
- (void)applicationWillEnterForeground{
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicAllLocation:[UserDefaultAcceess getMyID] Map:mapView View:self SituationCheck:YES];
    [dbAccess PicSearcherAndDiscover:[UserDefaultAcceess getBTOid] View:self.view];
    //タイマーの再設定
    tm = [NSTimer
          scheduledTimerWithTimeInterval:60.0f
          target:self
          selector:@selector(IntervalAction:)
          userInfo:nil
          repeats:YES];
}

// 定期的に呼ばれるメソッド
-(void)IntervalAction:(NSTimer*)timer{
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicAllLocation:[UserDefaultAcceess getMyID] Map:mapView View:self SituationCheck:NO];
    [locationManager startUpdatingLocation];
    [dbAccess PicSearcherAndDiscover:[UserDefaultAcceess getBTOid] View:self.view];
}

//----------------------------------------------------------------GPSに関する部分-----------------------------------------------------------

//位置情報サービスを開始するメソッド
- (void)StartLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // 取得精度を100m以内にする
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // GPSサービスの開始
        [locationManager startUpdatingLocation];
    }
}

// 標準位置情報サービスの取得に成功した場合
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    // 不要なデータは無視
    if (-[newLocation.timestamp timeIntervalSinceNow] > 5.0) return;
    if (newLocation.horizontalAccuracy > 100) return;
    
    //自分の位置情報をデータベースに送信
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess InsertDetailLocation:[UserDefaultAcceess getMyID] Latitude:[newLocation coordinate].latitude Longitude:[newLocation coordinate].longitude View:self];
    
    //一度位置情報を取得したらサービスを止める
    [manager stopUpdatingLocation];
}

// 標準位置情報サービス・大幅変更位置情報サービスの取得に失敗した場合
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // ここで任意の処理
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
    
    if ([error code] == kCLErrorDenied) {
        // 位置情報の利用が拒否されているので停止
        [manager stopUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
