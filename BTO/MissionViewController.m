//
//  MissionViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "MissionViewController.h"
#import "RootViewController.h"
#import "IIViewDeckController.h"


BOOL alertFinished;

@interface MissionViewController ()

@end


//基本的には地図と過去の位置を表したピンが刺さっている。
//ほかにも探している人数、見つけた人数、その人の情報などをのせたい
@implementation MissionViewController
@synthesize mapView;
@synthesize tm;


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
    [DataBaseAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self SituationCheck:YES];
    
    //----------------------------------facebookライクのためのボタン---------------------------------------------------------
    
    //LeftMenuに遷移するボタン
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(10, 20, 30, 30);
    back.backgroundColor = [UIColor clearColor];
    [back.titleLabel setFont:[UIFont systemFontOfSize:40]];
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
}

//LeftSlideMenuViewの呼び出し
-(void)back:(UIButton*)button{
     [self.viewDeckController toggleLeftViewAnimated:YES];
}

// BTOが存在しなくなった時にアラートのボタンが表示され、ボタンが押された時に呼ばれる
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIViewController *search = [[SearchViewController alloc]init];
    search.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:search animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
    }];
}

//----------------------------------裏側の処理（ホームからの復帰時のマーカーの更新＋マーカーの定期更新)------------------------------------------

//他の画面に遷移すると定期実行終了
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [tm invalidate];
    tm = nil;
}

//バックグラウンドに入ると定期実行終了
- (void)applicationDidEnterBackground{
    [tm invalidate];
    tm = nil;
}

//フォアグラウンドに戻ったときにマーカーを再描写
- (void)applicationWillEnterForeground{
    [DataBaseAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self SituationCheck:YES];
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
    NSLog(@"定期実行");
    [DataBaseAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self SituationCheck:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
