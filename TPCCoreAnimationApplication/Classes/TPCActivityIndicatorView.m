//
//  TPCActivityIndicatorView.m
//  150624核心动画练习
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCActivityIndicatorView.h"

#define TPCActivityIndicatorAnimationKey @"TPCActivityIndicator"
#define TPCActivityIndicatorDefaultPointsNumber 10
#define TPCActivityIndicatorDefaultPointsGroupsNumber 1
#define TPCActivityIndicatorDefaultPointsColor [UIColor blackColor]
#define TPCActivityIndicatorDefaultDuration 1.0

@interface TPCActivityIndicatorView ()
{
    /** 复制层 */
    CAReplicatorLayer *_replicatorLayer;
    /** 复制源层 */
    CALayer *_sourceLayer;
    /** 图层动画 */
    CABasicAnimation *_pointsAnimation;
}
@end

@implementation TPCActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算点尺寸时，默认控件为正方形
    CGFloat viewW = self.bounds.size.width;
    
    // 先让图层不显示，等动画开始后才显示
    _sourceLayer.transform = CATransform3DMakeScale(0, 0, 0);
    _sourceLayer.bounds = CGRectMake(0, 0, viewW / _pointsNumber, viewW / _pointsNumber);
    _sourceLayer.position = CGPointMake(viewW * 0.5, viewW / _pointsNumber);
    
    // 设置复制层属性
    CGFloat region = M_PI * 2 / _pointsNumber;
    _replicatorLayer.frame = self.bounds;
    _replicatorLayer.instanceCount = _pointsNumber;
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation(region, 0, 0, 1);
    _replicatorLayer.instanceDelay = -_duration / _pointsNumber * _pointsGroupsNumber;
    _replicatorLayer.backgroundColor = self.backgroundColor.CGColor;
}

- (void)setUp
{
    _pointsNumber = TPCActivityIndicatorDefaultPointsNumber;
    _pointsGroupsNumber = TPCActivityIndicatorDefaultPointsGroupsNumber;
    _duration = TPCActivityIndicatorDefaultDuration;
    
    // 创建复制源层
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = TPCActivityIndicatorDefaultPointsColor.CGColor;
    [_replicatorLayer addSublayer:layer];
    _sourceLayer = layer;
    
    // 创建复制层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    [self.layer addSublayer:replicatorLayer];
    _replicatorLayer = replicatorLayer;
    [_replicatorLayer addSublayer:_sourceLayer];
    
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.fromValue = @1.0;
    animation.toValue = @0.0;
    animation.repeatCount = MAXFLOAT;
    animation.duration = TPCActivityIndicatorDefaultDuration;
    _pointsAnimation = animation;
    [_sourceLayer addAnimation:_pointsAnimation forKey:TPCActivityIndicatorAnimationKey];
}

- (void)setPointsNumber:(NSInteger)pointsNumber
{
    if (!pointsNumber) {
        _pointsNumber = TPCActivityIndicatorDefaultPointsNumber;
    } else {
        _pointsNumber = pointsNumber;
    }
    
    [self layoutSubviews];
}

- (void)setPointsGroupsNumber:(NSInteger)pointsGroupsNumber
{
    if (!pointsGroupsNumber) {
        _pointsGroupsNumber = TPCActivityIndicatorDefaultPointsGroupsNumber;
    } else {
        _pointsGroupsNumber = pointsGroupsNumber;
    }
    
    [self layoutSubviews];
}

- (void)setPointsColor:(UIColor *)pointsColor
{
    if (!pointsColor) {
        _pointsColor = TPCActivityIndicatorDefaultPointsColor;
    } else {
        _pointsColor = pointsColor;
    }
    
    _sourceLayer.backgroundColor = _pointsColor.CGColor;
}

- (void)setPointsType:(TPCActivityIndicatorViewType)pointsType
{
    _pointsType = pointsType;
    
    // 设置运动点形状
    if (_pointsType == TPCActivityIndicatorViewTypeCircle) {
        _sourceLayer.cornerRadius = self.bounds.size.width / _pointsNumber / 2;
    }
}

- (void)setDuration:(CGFloat)duration
{
    _duration = duration;
    
    [_sourceLayer removeAnimationForKey:TPCActivityIndicatorAnimationKey];
    _pointsAnimation.duration = _duration;
    // 设置动画间隔
    // 如果先设置sourceLayer动画，再通过key获取sourceLayer的动画，在修改动画属性时，会出现崩溃情况
    [_sourceLayer addAnimation:_pointsAnimation forKey:TPCActivityIndicatorAnimationKey];
}
@end
