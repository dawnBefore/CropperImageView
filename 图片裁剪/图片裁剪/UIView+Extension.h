//
//  UIView+Extension.h
//  weibo
//
//  Created by lanou3g on 15/10/7.
//  Copyright (c) 2015年 songhaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
/** 屏幕的宽度 */
#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width
/** 屏幕的高度 */
#define ScreenHeigth    [[UIScreen mainScreen] bounds].size.height

// 给UIView添加方法, 方便使用的时候直接赋值
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
