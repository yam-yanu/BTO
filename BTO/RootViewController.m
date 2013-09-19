//
//  RootViewController.m
//  BTO
//
//  Created by ami on 2013/09/17.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end


//タイトル画面（探すボタンと探されるボタンがある）
@implementation RootViewController{
    GMSMapView *mapView_;
}

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
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    [DataBaseAccess PicLocation:mapView_];

}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id)marker{
    SSGentleAlertView* alert = [SSGentleAlertView new];
    alert.delegate = self;
    alert.title = @"SSGentleAlertView";
    alert.message = [marker title];
    //    alert.dialogImageView.image = [UIImage imageNamed:@"alert.png"];
    //
    //    UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert.png"]];
    //    image.center = CGPointMake(142, 194);
    //    [alert addSubview:image];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"OK"];
    alert.cancelButtonIndex = 0;
    [alert show];
    
    DataBaseAccess *database = [[DataBaseAccess alloc]init];
    [database DetailBTO:1];
//    alert.title = [[database detailBTO]objectAtIndex:0];
//    alert.message = [[database detailBTO]objectAtIndex:1];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        sleep(2);
//        alert.title = @"2回目";
//        alert.message = @"いけてるかな？";
//        [alert show];
//    });

    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
