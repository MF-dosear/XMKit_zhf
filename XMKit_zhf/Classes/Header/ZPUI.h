//
//  YXUI.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#ifndef YXUI_h
#define YXUI_h

/// 1像素线宽
#define LINE_WIDTH              1.f / [UIScreen mainScreen].scale

/// 屏幕
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

/// 屏幕尺寸
#define SCREEN_SIZE   SCREEN_BOUNDS.size

/// 屏幕宽高
#define SCREEN_WIDTH  SCREEN_SIZE.width
#define SCREEN_HEIGHT SCREEN_SIZE.height

/// 设备高度 判断设备
#define IS_IPHONE_4_4S          (SCREEN_HEIGHT == 480.0)
#define IS_IPHONE_5S_5SE        (SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6_6S_7_8      (SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P_6SP_7P_8P  (SCREEN_HEIGHT == 736.0)
#define IS_IPHONE_X_Xs          (SCREEN_HEIGHT == 812.0)
#define IS_IPHONE_Xr_XsMax      (SCREEN_HEIGHT == 896.0)

#endif /* YXUI_h */
