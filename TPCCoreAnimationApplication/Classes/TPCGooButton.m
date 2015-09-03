//
//  TPCGooView.m
//   
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCGooButton.h"

//////////////////////
// 这里求半径都采用height来处理，因为基本需求都是宽大于高，qq的消息提醒也是
//////////////////////

#define TPCGooViewMaxDistanceBetweenTwoCircle 100.0

@interface TPCGooButton ()
/** 小圆 */
@property (weak, nonatomic) UIView *smallView;

/** 不规则举行 */
@property (weak, nonatomic) CAShapeLayer *shapeLayer;
@end

@implementation TPCGooButton

#pragma mark 小圆懒加载
- (UIView *)smallView
{
    if (_smallView == nil) {
        UIView *smallView = [[UIView alloc] init];
        smallView.backgroundColor = self.backgroundColor;
        smallView.layer.cornerRadius = self.layer.cornerRadius;
        smallView.frame = self.frame;
        [self.superview insertSubview:smallView belowSubview:self];
        _smallView = smallView;
    }
    
    return _smallView;
}

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:shapeLayer below:self.layer];
        _shapeLayer = shapeLayer;
    }
    
    return _shapeLayer;
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
    self.backgroundColor = [UIColor redColor];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.height / 2;
    // 取消父控件的将Autoresizing自动转换成Constraints
    self.superview.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint translationPoint = [pan translationInView:self];
    
    CGPoint center = self.center;
    center.x += translationPoint.x;
    center.y += translationPoint.y;
    self.center = center;


    CGFloat buttonWH = self.bounds.size.height;
    
    CGFloat distance = [self distanceWithCircleCenter:self.center anotherCircleCenter:self.smallView.center];

//    distance = MIN(distance, TPCGooViewMaxDistanceBetweenTwoCircle);
    
    // 移动大圆，小圆半径减小,这里/1.5是为了不让小圆衰减太快
    CGFloat smallViewHW = buttonWH - distance * buttonWH / TPCGooViewMaxDistanceBetweenTwoCircle / 1.5;
    self.smallView.bounds = CGRectMake(0, 0, smallViewHW, smallViewHW);
    self.smallView.layer.cornerRadius = self.smallView.bounds.size.height / 2;
    
    // 如果距离大于0且小圆不隐藏，就绘制不规则矩形
    if (distance > 0 && self.smallView.hidden == NO) {
        // 绘制不规则矩形
        self.shapeLayer.path = [self pathWithCircleView:self anotherCircleView:self.smallView].CGPath;

    }
    
    // 大于最大距离就隐藏小圆，并移除不规则矩形
    if (distance >= TPCGooViewMaxDistanceBetweenTwoCircle) {
        self.smallView.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (distance > 0 && distance < TPCGooViewMaxDistanceBetweenTwoCircle) {
            // 隐藏小圆
            self.smallView.hidden = NO;
            // 移除不规则矩形
            [self.shapeLayer removeFromSuperlayer];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // 将大圆移至起点
                self.center = self.smallView.center;
            } completion:^(BOOL finished) {
                
            }];
            
        } else if(distance >= TPCGooViewMaxDistanceBetweenTwoCircle) {
            // 移除小圆
            [self.smallView removeFromSuperview];
            
            // 执行帧动画
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 1; i < 5; i++) {
                [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"unreadBomb_%d", i]]];
            }
            CGFloat imageViewX = (self.bounds.size.width - self.bounds.size.height) / 2;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, self.bounds.size.height, self.bounds.size.height)];
            imageView.animationImages = arrayM;
            imageView.animationDuration = 1.0;
            imageView.animationRepeatCount = 1;
            [imageView startAnimating];
            
            // 设置背景颜色和文字颜色为接近无色
            self.backgroundColor = [UIColor clearColor];
            [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            [self addSubview:imageView];
            // 动画执行完毕后移除大圆
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    }
    
    [pan setTranslation:CGPointZero inView:self];
}

- (UIBezierPath *)pathWithCircleView:(UIView *)view anotherCircleView:(UIView *)anotherView
{
    CGFloat viewX = view.center.x;
    CGFloat viewY = view.center.y;
    CGFloat anotherViewX = anotherView.center.x;
    CGFloat anotherViewY = anotherView.center.y;
    CGFloat viewR = view.frame.size.height / 2;
    CGFloat anotherViewR = anotherView.frame.size.height / 2;
    CGFloat distance = [self distanceWithCircleCenter:view.center anotherCircleCenter:anotherView.center];
    CGFloat cosθ = (viewY - anotherViewY) / distance;
    CGFloat sinθ = (viewX - anotherViewX) / distance;
    
    CGPoint pointA = CGPointMake(anotherViewX + anotherViewR * cosθ, anotherViewY - anotherViewR * sinθ);
    CGPoint pointB = CGPointMake(anotherViewX - anotherViewR * cosθ, anotherViewY + anotherViewR * sinθ);
    CGPoint pointC = CGPointMake(viewX - viewR * cosθ, viewY + viewR * sinθ);
    CGPoint pointD = CGPointMake(viewX + viewR * cosθ, viewY - viewR * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + distance / 2 * sinθ, pointA.y + distance / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + distance / 2 * sinθ, pointB.y + distance / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addQuadCurveToPoint:pointD controlPoint:pointO];
    [path addLineToPoint:pointC];
    [path addQuadCurveToPoint:pointB controlPoint:pointP];
    [path closePath];
    
    return path;
}
- (CGFloat)distanceWithCircleCenter:(CGPoint)center anotherCircleCenter:(CGPoint)anotherCenter
{
    CGFloat distanceX = center.x - anotherCenter.x;
    CGFloat distanceY = center.y - anotherCenter.y;
    
    return sqrtf(distanceX * distanceX + distanceY * distanceY);
}




@end
