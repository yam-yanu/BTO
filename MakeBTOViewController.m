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
    
    //　ナビゲーションバーの作成
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"プロフィール作成"];
    // ナビゲーションバーにナビゲーションアイテムを設置
    [navBar pushNavigationItem:title animated:YES];

    // 戻るボタンを生成
    UIBarButtonItem* Backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBack:)];
    //　編集ボタンを生成
    UIBarButtonItem *Editbtn = [[UIBarButtonItem alloc] initWithTitle:@"編集" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEdit:)];

    // ナビゲーションアイテムの左側に戻るボタン、右側に編集ボタンを設置
    title.leftBarButtonItem = Backbtn;
    title.rightBarButtonItem = Editbtn;

    [self.view addSubview:navBar];

    
    //　テーブルビューの作成
    table = [[UITableView alloc]initWithFrame:CGRectMake(0,45,320,480) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    //　作成完了ボタンの作成
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
    [complete setTitle:@"無効ボタン" forState:UIControlStateDisabled];
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
     NSLog(@"ボタンを押されましたね");
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"戻りてえ");
        [UserDefaultAcceess ChangeState:0];
        NSLog(@"戻った？");
    }];

    
}

    //　編集ボタンが押されたときに呼ばれるメソッド
-(void)clickEdit:(UIBarButtonItem*)btn{
     //　編集モードにする
    [table setEditing:YES animated:YES];
    //編集モード解除
//    [table setEditing:NO animated:YES];

}

    //　編集ボタンが押されたときに呼ばれるメソッド
-(void)complete:(UIBarButtonItem*)btn{
    NSLog(@"保存するよ");
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *nameLabel;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //ラベルとテキストの境界線を引く
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 2, cell.contentView.bounds.size.height)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.autoresizingMask = 0x3f;
        
        [cell.contentView addSubview:lineView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *textFont = [UIFont systemFontOfSize:17.0];
        
        // ラベル
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 130, 50)];
        nameLabel.backgroundColor = [UIColor clearColor];
        [nameLabel setFont:textFont];
        //nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:nameLabel];
        
        // テキスト
        textField = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 0.0f, 220.0f, 50.0f)];
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
