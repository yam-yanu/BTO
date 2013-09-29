//
//  MakeBTOViewController.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "MakeBTOViewController.h"
#import "RootViewController.h"
#import "DataBaseAccess.h"

@interface MakeBTOViewController ()

@end


//探されるときに必要な情報を入力する
//だいたいの場所？、写真？、特徴、何時まで？
@implementation MakeBTOViewController

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
    //ナビゲーションバーの作成
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"プロフィール作成"];
    // ナビゲーションバーにナビゲーションアイテムを設置
    [navBar pushNavigationItem:title animated:YES];

    // 戻るボタンを生成
    UIBarButtonItem* Backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBack:)];
    //編集ボタンを生成
    UIBarButtonItem *Editbtn = [[UIBarButtonItem alloc] initWithTitle:@"編集" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEdit:)];

    // ナビゲーションアイテムの左側に戻るボタン、右側に編集ボタンを設置
    title.leftBarButtonItem = Backbtn;
    title.rightBarButtonItem = Editbtn;

    [self.view addSubview:navBar];

    
    //テーブルビューの作成
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0,45,320,480) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    //作成完了ボタンの作成
    UIButton *complete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    complete.frame = CGRectMake(110, 320, 100, 40);
    complete.backgroundColor = [UIColor clearColor];
    [complete setTitle:@"登録する" forState:UIControlStateNormal];
    [complete addTarget:self
             action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:complete];
    
}

//戻るボタンが押されたときに呼ばれるメソッド
-(void)clickBack:(UIBarButtonItem*)btn{
     NSLog(@"ボタンを押されましたね");
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"戻りてえ");
        [UserDefaultAcceess ChangeState:0];
        NSLog(@"戻った？");
    }];

    
}

//編集ボタンが押されたときに呼ばれるメソッド
-(void)clickEdit:(UIBarButtonItem*)btn{
    NSLog(@"編集するよ");
   // [self UpdateBTO];
}

//編集ボタンが押されたときに呼ばれるメソッド
-(void)complete:(UIBarButtonItem*)btn{
    NSLog(@"編集するよ");
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;//行の高さ　これは無くてもいい
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
    
    // Configure the cell...
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
