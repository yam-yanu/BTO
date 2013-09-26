//
//  RootViewController.m
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end


//タイトル画面（探すボタンと探されるボタンがある）
@implementation RootViewController{
    GMSMapView *mapView_;
}

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
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38
                                                            longitude:136.5
                                                                 zoom:5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    DataBaseAccess *database = [[DataBaseAccess alloc]init];
    NSLog(@"あなたのIDは%d番です",[database RegisterUser]);
    [DataBaseAccess PicLocation:mapView_];
    
    
    
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{

    
}
//マーカーをクリックしたとき
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id)marker{
    // ロード中インジケータを表示させる
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] init];
    ai.frame = CGRectMake(0, 0, 50, 50);
    ai.center = self.view.center;
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:ai];
    [ai startAnimating];

    //データベースから必要な情報を取得
    DataBaseAccess *database = [[DataBaseAccess alloc]init];
    [database DetailBTO:[[marker title] intValue] View:self];
    
    //ロードインジケータを止める
    [ai stopAnimating];

    return YES;
}

// アラートのボタンが押された時に呼ばれるデリゲート
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"ボタン押された");
    UIViewController *next = [[MissionViewController alloc]init];
    
    switch (buttonIndex) {
        case 0:
            //キャンセルのボタンが押されたときの処理を記述する
            break;
        case 1:
            //「この人を捜す」のボタンが押されたときの処理を記述する
            //ここに画面遷移を記述
            next.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:next animated:YES completion:^ {
                // 完了時の処理をここに書きます
                NSLog(@"完了した");
            }];
            break;
    }
    
}



- (void)applicationWillEnterForeground
{
    NSLog(@"applicationWillEnterForeground");
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    alert.title = @"BTOおらんパターン";
    alert.message = @"やらかした！";
    [alert addButtonWithTitle:@"OK"];
    alert.cancelButtonIndex = 0;
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
