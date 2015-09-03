//
//  TPCParticleView.h
//   
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCParticleView : UIView

/** 动画间隔 */
@property (assign, nonatomic) CGFloat duration;

/** 运动点个数 */
@property (assign, nonatomic) NSInteger pointsNumber;

/** 运动点颜色 */
@property (strong, nonatomic) UIColor *pointsColor;
@end
