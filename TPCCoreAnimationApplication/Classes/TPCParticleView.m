//
//  TPCParticleView.m
//  150624核心动画练习
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCParticleView.h"

#define TPCParticleViewAnimationKey @"TPCParticle"
#define TPCParticleViewAnimationDefaultDuration 3

@interface TPCParticleView ()
{
    CAReplicatorLayer *_replicator;
}

/** 路径 */
@property (strong, nonatomic)  UIBezierPath *path;

/** 源图层 */
@property (weak, nonatomic) CALayer *sourceLayer;

/** 路径动画 */
@property (strong, nonatomic) CAKeyframeAnimation *animation;
@end

@implementation TPCParticleView

#pragma mark 懒加载
- (UIBezierPath *)path
{
    if (_path == nil) {
        _path = [UIBezierPath bezierPath];
    }
    
    return _path;
}

- (CALayer *)sourceLayer
{
    if (_sourceLayer == nil) {
        CALayer *layer = [CALayer layer];
        layer.bounds = CGRectMake(0, 0, 10, 10);
        layer.position = CGPointMake(MAXFLOAT, MAXFLOAT);
        layer.backgroundColor = [UIColor blackColor].CGColor;
        layer.cornerRadius = 5;
        _sourceLayer = layer;
    }
    
    return _sourceLayer;
}

- (CAKeyframeAnimation *)animation
{
    if (_animation == nil) {
        // 添加动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.repeatCount = MAXFLOAT;
        animation.duration = TPCParticleViewAnimationDefaultDuration;
        _animation = animation;
    }
    
    return _animation;
}

- (void)drawRect:(CGRect)rect {
    [_path stroke];
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
    _duration = TPCParticleViewAnimationDefaultDuration;
    _pointsNumber = 1;
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
    // 创建复制层
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.bounds;
    [self.layer addSublayer:replicator];
    _replicator = replicator;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        // 清除路径、移除源图层
        self.path = nil;
        // 移除源图层后，复制的图层也会被移除
        [self.sourceLayer removeFromSuperlayer];
        self.sourceLayer = nil;
        
        [self setNeedsDisplay];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint locationPoint = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        // 设置路径起点
        [self.path moveToPoint:locationPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        // 添加路径
        [self.path addLineToPoint:locationPoint];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        // 修改动画路径
        [self.sourceLayer removeAnimationForKey:TPCParticleViewAnimationKey];
        self.animation.path = self.path.CGPath;
        [self.sourceLayer addAnimation:self.animation forKey:TPCParticleViewAnimationKey];
        
        [_replicator addSublayer:self.sourceLayer];
        
        // 赋值图层个数
        _replicator.instanceCount = _pointsNumber;
        _replicator.instanceDelay = self.duration / _pointsNumber;
    }
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)setDuration:(CGFloat)duration
{
    if (!duration) {
        _duration = TPCParticleViewAnimationDefaultDuration;
    } else {
        _duration = duration;
    }
    
    [self.sourceLayer removeAnimationForKey:TPCParticleViewAnimationKey];
    self.animation.duration = _duration;
    [self.sourceLayer addAnimation:self.animation forKey:TPCParticleViewAnimationKey];
}

// 不能动态改变点个数
- (void)setPointsNumber:(NSInteger)pointsNumber
{
    if (!pointsNumber) {
        _pointsNumber = 1;
    } else {
        _pointsNumber = pointsNumber;
    }
}

- (void)setPointsColor:(UIColor *)pointsColor
{
    _pointsColor = pointsColor;
    
    self.sourceLayer.backgroundColor = pointsColor.CGColor;
}

@end
