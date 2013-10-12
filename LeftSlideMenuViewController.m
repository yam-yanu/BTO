//
//  LeftSlideMenuViewController.m
//  BTO
//
//  Created by 小寺 貴士 on 2013/10/06.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "LeftSlideMenuViewController.h"
#import "IIViewDeckController.h"
#import "UserDefaultAcceess.h"
#import  "MakeBTOViewController.h"
@interface LeftSlideMenuViewController ()

@end

@implementation LeftSlideMenuViewController

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
    
    UIView *uv = [[UIView alloc] init];
    uv.frame = self.view.bounds;
    uv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:uv];
    
    //最初の画面に戻るボタン
    UIButton *start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    start.frame = CGRectMake(10, 30, 120, 30);
    start.backgroundColor = [UIColor clearColor];
    [start setTitle:@"最初の画面に戻る" forState:UIControlStateNormal];
    [start addTarget:self
               action:@selector(startbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    //BTOのステータスを見るボタン
    UIButton *info = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    info.frame = CGRectMake(10, 60, 100, 30);
    info.backgroundColor = [UIColor clearColor];
    [info setTitle:@"BTO情報" forState:UIControlStateNormal];
    [info addTarget:self
              action:@selector(infobtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:info];
    
    //閉じるボタン　＊画面タップでスライド閉じるが出来たら消去
    UIButton *close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    close.frame = CGRectMake(10, 90, 100, 30);
    close.backgroundColor = [UIColor clearColor];
    [close setTitle:@"閉じる" forState:UIControlStateNormal];
    [close addTarget:self
             action:@selector(closebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];

}


//　戻るボタンが押されたときに呼ばれるメソッド
-(void)startbtn:(UIButton*)btn{
    UIViewController *root = [[RootViewController alloc]init];
    root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:root animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:0];
    }];

}

//　BTO情報作成ボタンが押されたときに呼ばれるメソッド
-(void)infobtn:(UIButton*)btn{
    UIViewController *info = [[MakeBTOViewController alloc]init];
    info.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:info animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:2];
    }];
    
}


//　閉じるボタンが押されたときに呼ばれるメソッド
-(void)closebtn:(UIButton*)btn{
    [self.viewDeckController closeLeftViewAnimated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
