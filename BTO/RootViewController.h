//
//  RootViewController.h
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "MakeBTOViewController.h"
#import "IIViewDeckController.h"
#import "SSGentleAlertView.h"
@interface RootViewController : UIViewController<GMSMapViewDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) UIViewController *RootViewController;
@property (strong, nonatomic) IIViewDeckController *deckController;

@end
