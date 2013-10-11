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
#import "IIViewDeckController.h"
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
    
    //----------------------------------ナビゲーションバー部分を書く---------------------------------------------------------
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"プロフィール作成"];

    [navBar pushNavigationItem:title animated:YES];

    UIBarButtonItem* Backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBack:)];

    title.leftBarButtonItem = Backbtn;

    [self.view addSubview:navBar];

    
    //----------------------------------テーブルビュー部分を書く---------------------------------------------------------
    table = [[UITableView alloc]initWithFrame:CGRectMake(0,45,320,480) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    //----------------------------------登録完了ボタンを書く---------------------------------------------------------
    UIButton *complete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    UIImage *img = [UIImage imageNamed:@"btnR10.png"]; 
    complete.frame = CGRectMake(110, 320, 100, 40);
    complete.backgroundColor = [UIColor clearColor];

    [complete setBackgroundImage:img forState:UIControlStateNormal];
    
    [complete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [complete setTitle:@"登録する" forState:UIControlStateNormal];
    [complete addTarget:self
             action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    
    // 無効時のボタンタイトル設定
    [complete setTitle:@"登録する" forState:UIControlStateDisabled];
    [self.view addSubview:complete];
    
    //　キーボードの外をタップした時
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [table addGestureRecognizer:self.singleTap];
}

    //　returnを押した時にキーボードが隠れる
- (BOOL)textFieldShouldReturn:(UITextField *)keyboard {
    [textField resignFirstResponder];
    return YES;
}

    //　背景がタップされた時の処理
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [textField resignFirstResponder];
}

    //　キーボードを表示していない時は、他のジェスチャに影響を与えないように無効化しておく。
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        // キーボード表示中のみ有効
        if (textField.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}


    //　戻るボタンが押されたときに呼ばれるメソッド
-(void)clickBack:(UIBarButtonItem*)btn{
    [self dismissViewControllerAnimated:YES completion:^{
        [UserDefaultAcceess ChangeState:0];
    }];
    [self.viewDeckController closeLeftViewAnimated:YES];

}

    //　登録完了ボタンが押されたときに呼ばれるメソッド
-(void)complete:(UIBarButtonItem*)btn{
    NSLog(@"保存するよ");
    //データベースに送信
    
    //MiddionForBTOViewControllerに遷移
    UIViewController *mfbv = [[MissionForBTOViewController alloc]init];
    mfbv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mfbv animated:YES completion:^ {
        [UserDefaultAcceess ChangeState:2];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *nameLabel;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIFont *textFont = [UIFont systemFontOfSize:15.0];
        
        // ラベル
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 130, 40)];
        nameLabel.backgroundColor = [UIColor clearColor];
        [nameLabel setFont:textFont];
        //nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:nameLabel];
        
        // テキスト
        textField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 0.0f, 220.0f, 40.0f)];
        textField.delegate = self;
        [textField setFont:textFont];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:textField];

        if (indexPath.row == 0)
        {
            [nameLabel setText:@"名前"];
            textField.placeholder = @"ニックネーム可";
            textField.returnKeyType = UIReturnKeyNext;
            //passTextFld.tag = TAG_USER_ID;
        }
        else if(indexPath.row == 1)
        {
            [nameLabel setText:@"特徴"];
            textField.placeholder = @"チャームポイント";
            textField.returnKeyType = UIReturnKeyDefault;
            //passTextFld.tag = TAG_FEATURE;
        }
        else
        {
            [nameLabel setText:@"一言"];
            textField.placeholder = @"なんでもどうぞ";
            textField.returnKeyType = UIReturnKeyDefault;
            //passTextFld.tag = TAG_VOICE;
        }
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
