//
//  SearchViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "SearchViewController.h"
#import "IIViewDeckController.h"
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
    UIViewController *left = [[LeftSlideMenuViewController alloc] init];

    switch (buttonIndex) {
        case 0:
            //キャンセルのボタンが押されたときの処理を記述する
            break;
        case 1:
            //「この人を捜す」のボタンが押されたときの処理を記述する
            //MissionViewControllerに遷移
            [[[DataBaseAccess alloc]init] AddSearcher:[UserDefaultAcceess getBTOid]];
            self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:mission leftViewController:left];
            self.deckController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:self.deckController animated:YES completion:^ {
                [UserDefaultAcceess ChangeState:1];
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
