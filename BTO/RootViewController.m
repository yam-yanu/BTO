//
//  RootViewController.m
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
//#import "MissionViewController.h"
#import "SSDialogView.h"

BOOL alertFinished;

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
    
    [DataBaseAccess PicLocation:mapView_];

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
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    DataBaseAccess *database = [[DataBaseAccess alloc]init];
    [database DetailBTO:[[marker title] intValue] alert:alert];
    
    //ロードインジケータを止める
    [ai stopAnimating];
    
    alert.title = @"SSGentleAlertView";
    alert.message = [marker title];
    //    alert.dialogImageView.image = [UIImage imageNamed:@"alert.png"];
    //
    //    UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert.png"]];
    //    image.center = CGPointMake(142, 194);
    //    [alert addSubview:image];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"OK"];
    alert.cancelButtonIndex = 0;
    
    
    //    // ダイアログ部分の画像はなしにする
    //    alert.dialogImageView.image = nil;
    //
    //    // タイトルラベルとメッセージラベルの色を変更
    //    alert.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    //    alert.titleLabel.shadowColor = UIColor.clearColor;
    //    alert.messageLabel.textColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.0 alpha:1.0];
    //    alert.messageLabel.shadowColor = UIColor.clearColor;
    //
    //    // ボタンの背景画像とフォント色を変更
    //    UIButton* button = [alert buttonBase];
    //    [button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_normal"]] forState:UIControlStateNormal];
    //    [button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_pressed"]] forState:UIControlStateHighlighted];
    //    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    //    [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    //    [alert setButtonBase:button];
    //    [alert setDefaultButtonBase:button];
    //
    [alert show];
    
    alertFinished = NO;  //グローバル変数
    //アラートでボタンを押すまで動作を中断する
    while (alertFinished == NO) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
    }

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
