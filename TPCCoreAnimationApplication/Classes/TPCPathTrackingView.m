//
//  TPCPathTrackingView.m
//  TPCCoreAnimationApplication
//
//  Created by tripleCC on 15/7/1.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCPathTrackingView.h"

@interface TPCPathTrackingView ()
/** 路径 */
@property (strong, nonatomic)  UIBezierPath *path;

@end

@implementation TPCPathTrackingView
#pragma mark 懒加载
- (UIBezierPath *)path
{
    if (_path == nil) {
        _path = [UIBezierPath bezierPath];
    }
    
    return _path;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint curPosition = [touch locationInView:self];
    
    [self.path moveToPoint:curPosition];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint curPosition = [touch locationInView:self];
    
    [self.path addLineToPoint:curPosition];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self startAnimation];
}

- (void)drawRect:(CGRect)rect
{
    [self.path stroke];
}

- (void)startAnimation
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = self.path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 0.0;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.duration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:nil];
    
    [self.path removeAllPoints];
    [self setNeedsDisplay];
}

@end
