//
//  TPCInvertView.m
//   
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "TPCInvertImageView.h"

@interface TPCInvertImageView ()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation TPCInvertImageView

// 使view的layer为复制图层类型
+ (Class)layerClass
{
    return [CAReplicatorLayer class];
}

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

- (void)setUp
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CAReplicatorLayer *relicatorLayer = (CAReplicatorLayer *)self.layer;
    relicatorLayer.instanceCount = 2;
    
    // 也可以通过复制层设置锚点，直接绕x轴旋转，但是要更改position，以消除UIView在父控件位置的偏移
    CATransform3D transform = CATransform3DMakeTranslation(0, self.bounds.size.height, 0);
    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    relicatorLayer.instanceTransform = transform;
    relicatorLayer.instanceAlphaOffset = -0.1;
    relicatorLayer.instanceBlueOffset = -0.1;
    relicatorLayer.instanceGreenOffset = -0.1;
    relicatorLayer.instanceRedOffset = -0.1;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

@end
