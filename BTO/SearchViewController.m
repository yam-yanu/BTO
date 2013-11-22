//
//  SearchViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "SearchViewController.h"
@interface SearchViewController ()

@end

//地図とピンを表示し、ピンをクリックするとその人を捜すかダイアログで聞かれる
//OKならその人の地図と情報に画面遷移
@implementation SearchViewController
@synthesize mapView;

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
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.delegate = self;
    self.view = mapView;
    DataBaseAccess *dbAccess = [[DataBaseAccess alloc]init];
    [dbAccess PicLocation:mapView View:self];
    
    //----------------------------------ナビゲーションバー(iOS6/7対応)を書く---------------------------------------------------------
    
    UINavigationBar *navBar = [[UINavigationBar alloc]init];
    if(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
        navBar.frame = CGRectMake(0,0,320,45);
    }else{
        navBar.frame = CGRectMake(0,0,320,55);
    }
    UINavigationItem *title = [[UINavigationItem alloc]init];
    if([UserDefaultAcceess getState] == 0){
        title.title = @"プロフィール作成";
    }else{
        title.title = @"プロフィール変更";
    }
    [navBar pushNavigationItem:title animated:YES];
    UIBarButtonItem* Backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBack:)];
    title.leftBarButtonItem = Backbtn;
    [self.view addSubview:navBar];
}


//マーカーをクリックしたとき
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id)marker{
    
    //データベースから必要な情報を取得
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    DataBaseAccess *database = [[DataBaseAccess alloc]init];
    [database DetailBTO:[[marker title] intValue] View:self];
    [UserDefaultAcceess RegisterBTOid:[[marker title] intValue]];
    
    return YES;
}

// アラートのボタンが押された時に呼ばれるデリゲート
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIViewController *mission = [[MissionViewController alloc]init];

    switch (buttonIndex) {
        case 0:
            //キャンセルのボタンが押されたときの処理を記述する
            break;
        case 1:
            //「この人を捜す」のボタンが押されたときの処理を記述する
            //MissionViewControllerに遷移
            [[[DataBaseAccess alloc]init] AddSearcher:[UserDefaultAcceess getBTOid]];
            mission.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:mission animated:YES completion:^ {
                [UserDefaultAcceess ChangeState:1];
            }];
            break;
    }
    
}

//　戻るボタンが押されたときに呼ばれるメソッド
-(void)clickBack:(UIBarButtonItem*)btn{
    [self dismissViewControllerAnimated:YES completion:^{
        [UserDefaultAcceess ChangeState:0];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
