//
//  MissionViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "MissionViewController.h"
#import "SSDialogView.h"

BOOL alertFinished;

@interface MissionViewController ()

@end


//基本的には地図と過去の位置を表したピンが刺さっている。
//ほかにも探している人数、見つけた人数、その人の情報などをのせたい
@implementation MissionViewController{
    GMSMapView *mapView_;

    UIButton* button;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(0.0, 160.0, 320.0, 40.0);
    [button setTitle:@"成功" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button]; //    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/hello.php"];
//    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
//    [request setHTTPMethod:@"POST"];
//    [request addBody:@"test" forKey:@"TestKey"];
//    [request setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
//        NSLog(@"%@", responseString);
//    }];
//    [request startRequest];
//    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
//                                                            longitude:151.20
//                                                                 zoom:6];
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.delegate = self;
//    self.view = mapView_;
//    
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView_;
    

}



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id)marker{
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    alert.title = @"SSGentleAlertView";
    alert.message = [marker title];
    //    alert.dialogImageView.image = [UIImage imageNamed:@"alert.png"];
    //
    //    UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert.png"]];
    //    image.center = CGPointMake(142, 194);
    //    [alert addSubview:image];
    [alert addButtonWithTitle:@"探す"];
    [alert addButtonWithTitle:@"探さない"];
    alert.cancelButtonIndex = 0;
    
//
//    // ダイアログ部分の画像はなしにする
//    alert.dialogImageView.image = nil;
//
//    // タイトルラベルとメッセージラベルの色を変更
//    alert.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
//    alert.titleLabel.shadowColor = UIColor.whiteColor;
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
//    [alert show];
    
    alertFinished = YES;  //グローバル変数
    //アラートでボタンを押すまで動作を中断する
    while (alertFinished == NO) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
