//
//  EditViewController.m
//  TrimmingImageView
//
//  Created by tanaka on 12/05/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"

@interface MaskView : UIView
@end
@implementation MaskView

- (id)initWithFrame:(CGRect)frame FrameSize:(float)frameSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
    }
    return self;
}


//フレームの開始位置、サイズを設定
- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    //明るい方のフレームを設定
    CGRect cRect = CGRectMake((self.frame.size.width/2-90), (self.frame.size.height/2-90), 180, 180);
    //くらい方（外側）のフレームを設定
    CGRect sRect = CGRectMake((self.frame.size.width/2-89.5), (self.frame.size.height/2-90), 180, 180);
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextClearRect(context, cRect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:0.4f].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, sRect);
}

@end

@implementation EditViewController

@synthesize screen = _screen;
@synthesize iview = _iview;

- (id)initWithPickerImage:(UIImage *)data setInfo:(NSDictionary *)info FrameSize:(float)frameSize
{
    self = [super init];
    if (self) {
        imageData = data;
        imageInfo = info;
        trimmingSize = frameSize;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //バックグラウンドに画像を設置
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"trim_background.png"]];
    
    _screen = [[UIScrollView alloc] initWithFrame:
               CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    _iview = [[UIImageView alloc] initWithImage:imageData];
    
    [self.view addSubview:_screen];
    [_screen addSubview:_iview];
    
    _screen.maximumZoomScale = 2.0;
    if(self.view.frame.size.width/_iview.frame.size.width){
    _screen.minimumZoomScale = self.view.frame.size.width/_iview.frame.size.width;
    }
    _screen.clipsToBounds = NO;
    _screen.delegate = self;
    
    [_screen setZoomScale:_screen.minimumZoomScale];
    
    _screen.contentSize = _iview.frame.size;
    //  _screen.contentOffset = CGPointMake(0, -(self.view.frame.size.height/2-_iview.frame.size.height/2));
    _screen.contentOffset = CGPointMake(0, -(self.view.frame.size.height/2-_iview.frame.size.height/2));
    NSLog(@"%f,%f",self.view.frame.size.width,_iview.frame.size.width);
    _screen.contentInset = UIEdgeInsetsMake(140, (_iview.frame.size.width/2 - trimmingSize/2), 139, ((_iview.frame.size.width/2 - trimmingSize/2)-1));
    
    _screen.showsVerticalScrollIndicator = NO;
    _screen.showsHorizontalScrollIndicator = NO;
    
    MaskView *mask = [[MaskView alloc] initWithFrame:_screen.frame FrameSize:trimmingSize];
    [self.view addSubview:mask];
    mask.userInteractionEnabled = NO;
    
    UIBarButtonItem *spacer =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *saveBtn =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
    self.toolbarItems = [NSArray arrayWithObjects:cancelBtn,spacer,saveBtn, nil];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _iview;
}

#pragma mark - UIToolbar selector methods

- (void)save
{
    CGPoint offset = _screen.contentOffset;
    float __x = (offset.x+(self.view.frame.size.width/2-90))/_screen.zoomScale;
    float __y = (offset.y+(self.view.frame.size.height/2-90))/_screen.zoomScale;
    float _w = 180/_screen.zoomScale;
    float _h = 180/_screen.zoomScale;
    
//    UIImage *temp =[[_iview.image cutImage:CGRectMake(__x, __y, _w, _h)] shrinkImage:CGSizeMake(1280, 720)];    
    UIGraphicsBeginImageContext(imageData.size);
    [imageData drawInRect:CGRectMake(0, 0, imageData.size.width, imageData.size.height)];
    imageData = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef cgImage = CGImageCreateWithImageInRect(imageData.CGImage, CGRectMake(__x, __y, _w, _h));
    UIImage *cutImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    [_iview removeFromSuperview];
    
    _iview = [[UIImageView alloc] initWithImage:cutImage];

    _screen.minimumZoomScale = 180/_iview.frame.size.width;
    NSLog(@"self= %f,image = %f",self.view.frame.size.width,_iview.frame.size.width);
    [_screen setZoomScale:180/_iview.frame.size.width];
    [_screen addSubview:_iview];
    
    NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation( cutImage )];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pngData forKey:@"Picture"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"complete");
    }];
    
}

-(void)savePhoto:(UIImage*)orizinalSizeImage{
    UIImageWriteToSavedPhotosAlbum(orizinalSizeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//写真保存後にコールバックされる
-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if(error){//エラーのとき
        
    }else{//保存できたとき
        
    }
}


- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
