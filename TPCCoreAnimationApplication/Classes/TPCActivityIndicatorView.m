//
//  TPCActivityIndicatorView.m
//  150624核心动画练习
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCActivityIndicatorView.h"

#define TPCActivityIndicatorAnimationKey @"TPCActivityIndicator"
#define TPCActivityIndicatorDefaultSportPoints 10
#define TPCActivityIndicatorDefaultSportPointsGroups 1
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
    // 计算点尺寸时，默认控件为正方形
    CGFloat viewW = self.bounds.size.width;
//    CGFloat viewH = self.bounds.size.height;
    
    // 先让图层不显示，等动画开始后才显示
    _sourceLayer.transform = CATransform3DMakeScale(0, 0, 0);
    _sourceLayer.backgroundColor = _pointsColor.CGColor;
    _sourceLayer.bounds = CGRectMake(0, 0, viewW / _pointsNumber, viewW / _pointsNumber);
    _sourceLayer.position = CGPointMake(viewW * 0.5, viewW / _pointsNumber);
    
    // 设置运动点形状
    if (_pointsType == TPCActivityIndicatorViewTypeCircle) {
        _sourceLayer.cornerRadius = viewW / _pointsNumber / 2;
    }

    // 设置动画间隔
    // 如果先设置sourceLayer动画，再通过key获取sourceLayer的动画，在修改动画属性时，会出现崩溃情况
    _pointsAnimation.duration = _duration;
    [_sourceLayer addAnimation:_pointsAnimation forKey:nil];
    
    // 设置复制层属性
    CGFloat region = M_PI * 2 / _pointsNumber;
    _replicatorLayer.frame = self.bounds;
    _replicatorLayer.instanceCount = _pointsNumber;
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation(region, 0, 0, 1);
    _replicatorLayer.instanceDelay = _duration / _pointsNumber * _pointsGroupsNumber;
    _replicatorLayer.backgroundColor = self.backgroundColor.CGColor;
    [_replicatorLayer addSublayer:_sourceLayer];
    
}

- (void)setUp
{
    // 创建复制子层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    [self.layer addSublayer:replicatorLayer];
    _replicatorLayer = replicatorLayer;
    
    // 创建复制源层
    CALayer *layer = [CALayer layer];
    [_replicatorLayer addSublayer:layer];
    _sourceLayer = layer;
    
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.fromValue = @1.0;
    animation.toValue = @0.0;
    animation.repeatCount = MAXFLOAT;
    _pointsAnimation = animation;

    // 默认点数、颜色、时间间隔、组数、点形状
    _pointsNumber = TPCActivityIndicatorDefaultSportPoints;
    _pointsColor = TPCActivityIndicatorDefaultPointsColor;
    _duration = TPCActivityIndicatorDefaultDuration;
    _pointsGroupsNumber = TPCActivityIndicatorDefaultSportPointsGroups;
    _pointsType = TPCActivityIndicatorViewTypeCircle;
}

- (void)setPointsNumber:(NSInteger)pointsNumber
{
    if (!pointsNumber) {
        _pointsNumber = TPCActivityIndicatorDefaultSportPoints;
    } else {
        _pointsNumber = pointsNumber;
    }
}
@end
