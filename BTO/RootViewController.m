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
    NSMutableArray *results = [[NSMutableArray alloc] init];
    results = [[[DataBaseAccess alloc]init] PicLocation];
    
    for(int i = 0;i<15;i++){
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"AAA");
    }
    for (NSDictionary *obj in results)
    {
        NSLog(@"%@",[obj objectForKey:@"title"]);
        NSLog(@"%@",[obj objectForKey:@"content"]);
        //        Entry *entry = [[Entry alloc] init];
        //        entry.title = [obj objectForKey:@"title"];
        //        entry.content = [obj objectForKey:@"content"];
        //        [results addObject:issue];
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;

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
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
