//
//  TPCFoldingImageView.m
//
//  Created by 宋瑞旺 on 15/6/24.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCFoldingImageView.h"

@interface TPCFoldingImageView ()
/** 图片上半部 */
@property (weak, nonatomic) UIImageView *topPartImage;

/** 图片下半部 */
@property (weak, nonatomic) UIImageView *bottomPartImage;

/** 渐变阴影 */
@property (weak, nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation TPCFoldingImageView

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageViewW = self.bounds.size.width;
    CGFloat imageViewH = self.bounds.size.height;

    //       ______
    //       |    |图片上半图
    //       |____|
    //       |    |图片下半图
    //       |____|
    // 设置上下部分为如上所示
    // 设置上下图片的尺寸为自定义ImageView的一半
    _topPartImage.frame = CGRectMake(0, 0, imageViewW, imageViewH * 0.5);
    _bottomPartImage.frame = CGRectMake(0, imageViewH * 0.5, imageViewW, imageViewH * 0.5);

    // 将图片截取成上下两半
    // 注意，要在ImageView的尺寸确定后才能进行以下设置
    _topPartImage.layer.contents = (id)_image.CGImage;
    _topPartImage.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    _bottomPartImage.layer.contents = (id)_image.CGImage;
    _bottomPartImage.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    
    // 设置阴影为下半图尺寸
    _gradientLayer.frame = _bottomPartImage.bounds;
}

- (void)setUp
{
    // 创建上下部分的ImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    _bottomPartImage = imageView;
    
    imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    _topPartImage = imageView;
    
    // 设置旋转锚点
    _topPartImage.layer.anchorPoint = CGPointMake(0.5, 1);
    _bottomPartImage.layer.anchorPoint = CGPointMake(0.5, 0);
    
    // 给自定义ImageView添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    // 渐变阴影
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradientLayer.opacity  = 0;
    [_bottomPartImage.layer addSublayer:gradientLayer];
    _gradientLayer = gradientLayer;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint translationPoint = [pan translationInView:self];
    
    CATransform3D transform3D = CATransform3DIdentity;
    
    // 设置立体效果，近大远小，前面－1保持不变
    transform3D.m34 = -1 / 300.0;
    
    // 每改变一个y坐标对应旋转弧度
    CGFloat radian = -M_PI / self.bounds.size.height * translationPoint.y;
    _topPartImage.layer.transform = CATransform3DRotate(transform3D, radian, 1, 0, 0);
    
    // 根据拖拽改变值设置阴影不透明度
    _gradientLayer.opacity = 1.0 / self.bounds.size.height * translationPoint.y;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 设置弹簧动画效果
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:8 options:UIViewAnimationOptionCurveLinear animations:^{
            // 还原形变与不透明度
            _topPartImage.layer.transform = CATransform3DIdentity;
            _gradientLayer.opacity  = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
