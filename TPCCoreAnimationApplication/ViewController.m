//
//  ViewController.m
//  TPCCoreAnimationApplication
//
//  Created by 宋瑞旺 on 15/6/24.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "ViewController.h"
#import "TPCActivityIndicatorView.h"
#import "TPCFoldingImageView.h"
#import "TPCGooButton.h"
#import "TPCInvertImageView.h"
#import "TPCParticleView.h"
#import "TPCPathTrackingView.h"

@interface ViewController ()
{
    TPCActivityIndicatorView *_activityIndicatorView;
    TPCGooButton *_gooButton1;
    TPCGooButton *_gooButton2;
    TPCFoldingImageView *_foldingImageView;
    TPCInvertImageView *_invertView;
    TPCParticleView *_particleView;
    TPCPathTrackingView *_pathTrackingView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityIndicatorView = [[TPCActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 0, 40, 40)];
    [self.view addSubview:_activityIndicatorView];
    
    _gooButton1= [[TPCGooButton alloc] initWithFrame:CGRectMake(100, 50, 25, 25)];
    [_gooButton1 setTitle:@"11" forState:UIControlStateNormal];
    [self.view addSubview:_gooButton1];
    
    _gooButton2= [[TPCGooButton alloc] initWithFrame:CGRectMake(200, 50, 40, 25)];
    [_gooButton2 setTitle:@"99+" forState:UIControlStateNormal];
    [self.view addSubview:_gooButton2];
    
    _foldingImageView = [[TPCFoldingImageView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
    _foldingImageView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_foldingImageView];
    
    _invertView = [[TPCInvertImageView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    _invertView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_invertView];
    
    _particleView = [[TPCParticleView alloc] initWithFrame:CGRectMake(100, 450, 200, 100)];
    _particleView.pointsNumber = 20;
    [self.view addSubview:_particleView];
    
    _pathTrackingView = [[TPCPathTrackingView alloc] initWithFrame:CGRectMake(100, 560, 200, 100)];
    _pathTrackingView.duration = 5.0;
    [self.view addSubview:_pathTrackingView];
    
    _activityIndicatorView.hidden = YES;
    _particleView.hidden = YES;
    _invertView.hidden = YES;
    _gooButton2.hidden = YES;
    _gooButton1.hidden = YES;
    _foldingImageView.hidden = YES;
    _pathTrackingView.hidden = YES;
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (IBAction)activity:(id)sender {
    _activityIndicatorView.hidden = NO;
}
- (IBAction)goo:(id)sender {
    _gooButton1.hidden = NO;
    _gooButton2.hidden = NO;
}
- (IBAction)folding:(id)sender {
    _foldingImageView.hidden = NO;
}
- (IBAction)invert:(id)sender {
    _invertView.hidden = NO;
}
- (IBAction)particle:(id)sender {
    _particleView.hidden = NO;
}
- (IBAction)tracking:(id)sender {
    _pathTrackingView.hidden = NO;
}


@end
