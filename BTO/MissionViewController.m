//
//  MissionViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "MissionViewController.h"
#import "RootViewController.h"
BOOL alertFinished;

@interface MissionViewController ()

@end


//基本的には地図と過去の位置を表したピンが刺さっている。
//ほかにも探している人数、見つけた人数、その人の情報などをのせたい
@implementation MissionViewController
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
    [DataBaseAccess PicAllLocation:[UserDefaultAcceess getBTOid] Map:mapView View:self];
    
    //rootViewに戻るボタン
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(10, 10, 30, 30);
    back.backgroundColor = [UIColor clearColor];
    [back setTitle:@"←" forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

-(void)back:(UIButton*)button{
    //SearchViewControllerに遷移
    UIViewController *root = [[RootViewController alloc]init];
    root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:root animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
