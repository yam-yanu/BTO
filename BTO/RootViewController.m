//
//  RootViewController.m
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//
#import "RootViewController.h"
BOOL alertFinished;

@interface RootViewController ()

@end


//タイトル画面（探すボタンと探されるボタンがある）
@implementation RootViewController

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
    //タイトルラベルを追加
	UILabel* title =[[UILabel alloc]initWithFrame:self.view.bounds];
	title.text = @"BLACK THUNDER OJISAN！";
    title.textAlignment = NSTextAlignmentCenter;
	title.backgroundColor = [UIColor whiteColor];
	title.textColor = [UIColor blackColor];
	title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:title];
	
    //探す側のボタン
    UIButton *search = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    search.frame = CGRectMake(20, 300, 100, 30);
    search.backgroundColor = [UIColor whiteColor];
    [search setTitle:@"探しに行く" forState:UIControlStateNormal];
    [search addTarget:self
            action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];

    //BTO側にいくボタン
    UIButton *bto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bto.frame = CGRectMake(200, 300, 100, 30);
    search.backgroundColor = [UIColor whiteColor];
    [bto setTitle:@"BTO" forState:UIControlStateNormal];
    [bto addTarget:self
            action:@selector(bto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bto];
    
    //もしもMyIDに０が入っていた場合アラートで知らせる
    if([UserDefaultAcceess getMyID] == 0){
        SSGentleAlertView* alert = [SSGentleAlertView new];
        alert.delegate = self;
        alert.title = @"通信エラー";
        alert.message = @"最初に通信エラーを起こしたためうまく動作できません\nもう一度通信を行います。";
        [alert addButtonWithTitle:@"OK"];
        alert.cancelButtonIndex = 0;
        [alert show];
    }
    
    
}

-(void)search:(UIButton*)button{
    //SearchViewControllerに遷移
    UIViewController *search = [[SearchViewController alloc]init];
    UIViewController *left = [[LeftSlideMenuViewController alloc] init];
    self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:search leftViewController:left];
    
    self.deckController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.deckController animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
        
    }];


}

-(void)bto:(UIButton*)button{
    //MakeBTOViewControllerに遷移
    UIViewController *bto = [[MakeBTOViewController alloc]init];
    bto.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:bto animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
    }];
    
}

// アラートのボタンが押された時に呼ばれるデリゲート
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    [SVProgressHUD show];
    [UserDefaultAcceess LaunchApp];
    if([UserDefaultAcceess getMyID] == 0){
        SSGentleAlertView* alert = [SSGentleAlertView new];
        alert.delegate = self;
        alert.title = @"通信エラー";
        alert.message = @"最初に通信エラーを起こしたため\nうまく動作できません\nもう一度通信を行います";
        [alert addButtonWithTitle:@"OK"];
        alert.cancelButtonIndex = 0;
        [alert show];
    }
    [SVProgressHUD dismiss];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
