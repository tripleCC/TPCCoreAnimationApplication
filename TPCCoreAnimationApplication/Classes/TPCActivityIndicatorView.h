//
//  TPCActivityIndicatorView.h
//  150624核心动画练习
//
//  Created by 宋瑞旺 on 15/6/25.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
  TPCActivityIndicatorViewTypeRect = 0,
  TPCActivityIndicatorViewTypeCircle 
} TPCActivityIndicatorViewType;

@interface TPCActivityIndicatorView : UIView
/** 动画时间间隔 */
@property (assign, nonatomic) CGFloat duration;

/** 运动点数 */
@property (assign, nonatomic) NSInteger pointsNumber;

/** 运动点组数 */
@property (assign, nonatomic) NSInteger pointsGroupsNumber;

/** 点背景颜色 */
@property (strong, nonatomic) UIColor *pointsColor;

/** 运动点形状 */
@property (assign, nonatomic) TPCActivityIndicatorViewType pointsType;

@end
