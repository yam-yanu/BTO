//
//  LeftSlideMenuViewController.h
//  BTO
//
//  Created by 小寺 貴士 on 2013/10/06.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSlideMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *table;
    UILabel *label;

}
@property (nonatomic, weak) UIViewController *LeftSlideMenuViewController;


@end