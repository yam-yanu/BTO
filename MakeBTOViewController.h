//
//  MakeBTOViewController.h
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeBTOViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UITableView *table;
    UILabel *label;
    UIView *tablecell;
    UITextField *textField;
}
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;



@end
