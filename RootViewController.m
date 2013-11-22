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
    

    //背景画像を追加
    UIImage *backgroundImage = [UIImage imageNamed:@"BTO.jpg"];
    CGRect r = [[UIScreen mainScreen] bounds];
    if (r.size.height == 480) {
        // iPhone4 or iPhone4S
        CGImageRef iphone5Image = CGImageCreateWithImageInRect(backgroundImage.CGImage, CGRectMake(0, 88, r.size.width,r.size.height));
        backgroundImage = [UIImage imageWithCGImage:iphone5Image];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    //探す側のボタン
    UIButton *search = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    search.frame = CGRectMake(0, 320, 120, 50);
    UIImage *button1 = [UIImage imageNamed:@"button1.png"];
    [search setBackgroundImage:button1 forState:UIControlStateNormal];
    [search addTarget:self
            action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];

    //BTO側にいくボタン
    UIButton *bto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bto.frame = CGRectMake(200, 320, 120, 50);
    UIImage *button2 = [UIImage imageNamed:@"button2.png"];
    [bto setBackgroundImage:button2 forState:UIControlStateNormal];
    [bto addTarget:self
            action:@selector(bto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bto];
    
    
    //もしもMyIDに０が入っていた場合アラートで知らせる
    if([UserDefaultAcceess getMyID] == 0){
        SSGentleAlertView* alert = [SSGentleAlertView new];
        alert.delegate = self;
        alert.tag = 1;
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
    search.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:search animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
    }];

}

-(void)bto:(UIButton*)button{
    if([UserDefaultAcceess getMyName]){
        //MakeBTOViewControllerに遷移
        UIViewController *bto = [[MakeBTOViewController alloc]init];
        bto.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:bto animated:YES completion:^ {
            [UserDefaultAcceess ChangeState:0];
        }];
    }else{
        SSGentleAlertView* alert = [SSGentleAlertView new];
        alert.delegate = self;
        alert.tag = 2;
        alert.title = @"注意";
        alert.message = @"おっさんになっている間はGPSをONにする必要があります。\nまた、現在位置が10分おきに\n他人に伝わります。\nそれでもおっさんになりますか？";
        [alert addButtonWithTitle:@"ならない"];
        [alert addButtonWithTitle:@"なる"];
        alert.cancelButtonIndex = 0;
        [alert show];
    }
    
}

// アラートのボタンが押された時に呼ばれるデリゲート
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1){
        [SVProgressHUD show];
        [UserDefaultAcceess LaunchApp];
        if([UserDefaultAcceess getMyID] == 0){
            SSGentleAlertView* alert = [SSGentleAlertView new];
            alert.delegate = self;
            alert.tag = 1;
            alert.title = @"通信エラー";
            alert.message = @"最初に通信エラーを起こしたため\nうまく動作できません\nもう一度通信を行います";
            [alert addButtonWithTitle:@"OK"];
            alert.cancelButtonIndex = 0;
            [alert show];
        }
        [SVProgressHUD dismiss];
    }else if(alertView.tag == 2){
        if(buttonIndex == 1){
            //MakeBTOViewControllerに遷移
            UIViewController *bto = [[MakeBTOViewController alloc]init];
            bto.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:bto animated:YES completion:^ {
                [UserDefaultAcceess ChangeState:0];
            }];
        }
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
