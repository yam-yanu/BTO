//
//  MissionForBTOViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "MissionForBTOViewController.h"
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
    //----------------------------------View部分を書く(マップやツールバーなど)---------------------------------------------------------
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38
                                                            longitude:136.5
                                                                 zoom:5];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.delegate = self;
    self.view = mapView;
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicAllLocation:[UserDefaultAcceess getMyID] Map:mapView View:self SituationCheck:YES];
    
    //探している人数、見つけた人数を表示
    [[[DataBaseAccess alloc]init] PicSearcherAndDiscover:[UserDefaultAcceess getMyID] View:self.view];
    
    
//    // ツールバーの表示
//    for(int row=0 ;row < 3; row++){
//        UIButton *tool = [UIButton buttonWithType:UIButtonTypeCustom];
//        tool.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width*row/3+1), 0, ([[UIScreen mainScreen] bounds].size.width/3-2), 44);
//        tool.backgroundColor = [UIColor blackColor];
//        [tool.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        tool.layer.cornerRadius = 0;
//        tool.clipsToBounds = true;
//        if(row == 0){
//            [tool setTitle:@"詳細" forState:UIControlStateNormal];
//            [tool addTarget:self
//                     action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
//        }else if(row == 1){
//            [tool setTitle:@"詳細の変更" forState:UIControlStateNormal];
//            [tool addTarget:self
//                     action:@selector(changeProfile:) forControlEvents:UIControlEventTouchUpInside];
//        }else{
//            [tool setTitle:@"リタイア" forState:UIControlStateNormal];
//            [tool addTarget:self
//                     action:@selector(giveup:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        [self.view addSubview:tool];
//    }
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) { //ios7以上
        // ツールバーを作成
        toolBar.frame = CGRectMake( 0, 20, [[UIScreen mainScreen] bounds].size.width, 60 );
        toolBar.tintColor = [UIColor darkGrayColor];
        //上の隙間をラベルで埋める
        UILabel *labelForToolBar = [[UILabel alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,80)];
        labelForToolBar.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:labelForToolBar];
    } else { //ios7未満
        // ツールバーを作成
        toolBar.frame = CGRectMake( 0, 0, [[UIScreen mainScreen] bounds].size.width, 60 );
        toolBar.tintColor = [UIColor darkGrayColor];
    }
    [self.view addSubview:toolBar];
    
    // スペーサを生成する
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    
    //ボタンを３つ生成する
    UIBarButtonItem *showDetail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BTOdetail"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(detail:)];
    UIBarButtonItem *changeDetail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"changeDetail"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(changeProfile:)];
    UIBarButtonItem *retaire = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"retire"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(giveup:)];

    // スペーサー（小）を生成
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor yellowColor];
    lbl.text = @"";
    UIBarButtonItem *lblbtn = [[UIBarButtonItem alloc] initWithCustomView:lbl];
    lblbtn.width = 20.0;
    
    // ボタン配列をツールバーに設定する
    toolBar.items = [ NSArray arrayWithObjects:lblbtn, showDetail, spacer, changeDetail, spacer, retaire ,lblbtn, nil ];
    
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
//------------------------------------------ボタンを押されたときの処理---------------------------------------------------------------------

//詳細を押したときの処理
-(void)detail:(UIButton*)button{
    [UserDefaultAcceess ChangeButtonState:1];
    [[DataBaseAccess new]DetailBTO:[UserDefaultAcceess getMyID] View:self];
}

//詳細を変更を押したときの処理
-(void)changeProfile:(UIButton*)button{

    [UserDefaultAcceess ChangeButtonState:0];
    UIViewController *make = [[MakeBTOViewController alloc]init];
    make.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:make animated:YES completion:^ {}];
    
}


//あきらめるを押したときの処理
-(void)giveup:(UIButton*)button{
    [UserDefaultAcceess ChangeButtonState:3];
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    alert.title = @"リタイア";
    alert.message = @"本当にあきらめますか？";
    [alert addButtonWithTitle:@"まだがんばる"];
    [alert addButtonWithTitle:@"あきらめる"];
    alert.cancelButtonIndex = 0;
    [alert show];
}

// アラート内のボタンが押されたときに呼ばれる、表示されているアラートの種類によって何をするか変える
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([UserDefaultAcceess getButtonState] == 1){//詳細
        [UserDefaultAcceess ChangeButtonState:0];
    }else if ([UserDefaultAcceess getButtonState] == 2){//詳細変更
        [UserDefaultAcceess ChangeButtonState:0];
    }else if ([UserDefaultAcceess getButtonState] == 3){//あきらめる
        if(buttonIndex == 1) {
            //あきらめるのボタンが押されたときRootViewに移動
            if([[DataBaseAccess new]StopBTO:[UserDefaultAcceess getMyID] View:self]){
                UIViewController *root = [[RootViewController alloc]init];
                root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:root animated:YES completion:^ {
                    [UserDefaultAcceess ChangeState:0];
                    [tm invalidate];
                    tm = nil;
                }];
            }
        }
        [UserDefaultAcceess ChangeButtonState:0];
    }else if([UserDefaultAcceess getButtonState] == 4){//GPSがONになってないとき
        if(buttonIndex == 0){
            SSGentleAlertView* alert = [SSGentleAlertView new];
            alert.delegate = self;
            alert.title = @"GPSがOFFになっています";
            alert.message = @"このアプリは消費電力に\nとても気を使っています。\nだからほんとお願いします。";
            [alert addButtonWithTitle:@"ONにしない"];
            [alert addButtonWithTitle:@"ONにする"];
            alert.cancelButtonIndex = 0;
            [alert show];
            [UserDefaultAcceess ChangeButtonState:4];
        }else{
//            NSString *schemeStr =  @"prefs:root=LOCATION_SERVICES";
//            NSURL *schemeURL = [NSURL URLWithString:schemeStr];
//            [[UIApplication sharedApplication] openURL:schemeURL];
            [UserDefaultAcceess ChangeButtonState:0];
        }
    }else{// BTOが自動的にリタイアになったときに呼ばれる
        if([[DataBaseAccess new]StopBTO:[UserDefaultAcceess getMyID] View:self]){
            UIViewController *root = [[RootViewController alloc]init];
            root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:root animated:YES completion:^ {
                [UserDefaultAcceess ChangeState:0];
                [tm invalidate];
                tm = nil;
            }];
        }
        [UserDefaultAcceess ChangeButtonState:0];
    }
    
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
    [dbAccess PicSearcherAndDiscover:[UserDefaultAcceess getMyID] View:self.view];
}

//----------------------------------------------------------------GPSに関する部分-----------------------------------------------------------

//位置情報サービスを開始するメソッド
- (void)StartLocationManager{
//    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // 取得精度を100m以内にする
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // GPSサービスの開始
        [locationManager startUpdatingLocation];
//    }else{
//        SSGentleAlertView* alert = [SSGentleAlertView new];
//        alert.delegate = self;
//        alert.title = @"GPSがOFFになっています";
//        alert.message = @"GPSをONにしないと\n遊べません。\nONにする場合、設定画面で\n位置情報サービスをONにしてください";
//        [alert addButtonWithTitle:@"ONにしない"];
//        [alert addButtonWithTitle:@"ONにする"];
//        alert.cancelButtonIndex = 0;
//        [alert show];
//        [UserDefaultAcceess ChangeButtonState:4];
//    }
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
