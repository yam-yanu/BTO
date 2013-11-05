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
    
    //----------------------------------View部分を書く(マップやツールバーなど)---------------------------------------------------------
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38
                                                            longitude:136.5
                                                                 zoom:5];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.delegate = self;
    self.view = mapView;
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self SituationCheck:YES];
    
    //探している人数、見つけた人数を表示
    [[[DataBaseAccess alloc]init] PicSearcherAndDiscover:[UserDefaultAcceess getBTOid] View:self.view];
    
    
//    // ツールバーの表示
//    for(int row=0 ;row < 3; row++){
//    UIButton *tool = [UIButton buttonWithType:UIButtonTypeCustom];
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
//            [tool setTitle:@"見つけた！" forState:UIControlStateNormal];
//            [tool addTarget:self
//                     action:@selector(discover:) forControlEvents:UIControlEventTouchUpInside];
//        }else{
//            [tool setTitle:@"あきらめる" forState:UIControlStateNormal];
//            [tool addTarget:self
//                     action:@selector(giveup:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        [self.view addSubview:tool];
//    }
    
    // ツールバーを作成
    UIToolbar * toolBar = [ [ UIToolbar alloc ] initWithFrame:CGRectMake( 0, 0, [[UIScreen mainScreen] bounds].size.width, 60 ) ];
    toolBar.tintColor = [UIColor darkGrayColor];
    // ツールバーを親Viewに追加
    [ self.view addSubview:toolBar ];
    
    // スペーサを生成する
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    
    //ボタンを３つ生成する
    UIBarButtonItem *showDetail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BTOdetail"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(detail:)];
    UIBarButtonItem *discover = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"discover"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(discover:)];
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
    toolBar.items = [ NSArray arrayWithObjects:lblbtn, showDetail, spacer, discover, spacer, retaire ,lblbtn, nil ];
    
    //----------------------------------裏側の処理の宣言（ホームからの復帰時のマーカーの更新＋マーカーの定期更新)------------------------------------------    
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

//------------------------------------------ボタンを押されたときの処理---------------------------------------------------------------------

//詳細を押したときの処理
-(void)detail:(UIButton*)button{
    [UserDefaultAcceess ChangeButtonState:1];
    [[DataBaseAccess new]DetailBTO:[UserDefaultAcceess getBTOid] View:self];
}

//見つけたを押したときの処理
-(void)discover:(UIButton*)button{
    [UserDefaultAcceess ChangeButtonState:2];
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    alert.title = @"合言葉を入力してください";
    alert.message = @"合い言葉はおっさんが\n教えてくれます\n\n\n";
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2-90), 235, 180, 30)];
    tf.delegate = self;
    tf.tag = 2;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"合い言葉を入れよう";
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.returnKeyType = UIReturnKeyDone;
    [alert addSubview:tf];
    [alert addButtonWithTitle:@"まだ知らない"];
    [alert addButtonWithTitle:@"OK"];
    alert.cancelButtonIndex = 0;
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
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

// BTOが存在しなくなった時にアラートのボタンが表示され、ボタンが押された時に呼ばれる
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([UserDefaultAcceess getButtonState] == 1){
        [UserDefaultAcceess ChangeButtonState:0];
    }else if ([UserDefaultAcceess getButtonState] == 2){
        if(buttonIndex == 1){
        UITextField *tf = (UITextField *)[alertView viewWithTag:2];
            if([[DataBaseAccess new]AddDiscover:[UserDefaultAcceess getMyID] BTOid:[UserDefaultAcceess getBTOid] PassWord:tf.text View:self]){
                SSGentleAlertView* alert = [SSGentleAlertView new];
                alert.delegate = self;
                alert.title = @"ミッション成功！";
                alert.message = @"おめでとう！\nおっさんからは\n何かもらえましたか？\nホーム画面に戻ります";
                [alert addButtonWithTitle:@"OK"];
                alert.cancelButtonIndex = 0;
                [alert show];
                [UserDefaultAcceess ChangeButtonState:4];
            }else{
                SSGentleAlertView* alert = [SSGentleAlertView new];
                alert.delegate = self;
                alert.title = @"合言葉が間違っています";
                alert.message = @"正しく合言葉を入力してください";
                [alert addButtonWithTitle:@"OK"];
                alert.cancelButtonIndex = 0;
                [alert show];
                [UserDefaultAcceess ChangeButtonState:1];
            }
        }
    }else if ([UserDefaultAcceess getButtonState] == 3){
        if(buttonIndex == 1) {
            //あきらめるのボタンが押されたときRootViewに移動
            UIViewController *root = [[RootViewController alloc]init];
            root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:root animated:YES completion:^ {
                [UserDefaultAcceess ChangeState:0];
                [[DataBaseAccess new]RemoveSearcher:[UserDefaultAcceess getBTOid]];
            }];
        }
        [UserDefaultAcceess ChangeButtonState:0];
    }else if([UserDefaultAcceess getButtonState] == 4){
        UIViewController *root = [[RootViewController alloc]init];
        root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:root animated:YES completion:^ {
            [UserDefaultAcceess ChangeState:0];
        }];
        [UserDefaultAcceess ChangeButtonState:0];
    }else{
        UIViewController *search = [[SearchViewController alloc]init];
        search.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:search animated:YES completion:^ {
            [UserDefaultAcceess ChangeState:0];
        }];
        [UserDefaultAcceess ChangeButtonState:0];
    }
    
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
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self SituationCheck:YES];
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
    [dbAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self SituationCheck:NO];
    [dbAccess PicSearcherAndDiscover:[UserDefaultAcceess getBTOid] View:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
