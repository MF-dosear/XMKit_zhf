//
//  TKScreen.h
// Hello
//
//  Created by G.E.M on 2023/8/15.
//  Copyright © 2021 Hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OVScreenOrientation) {
    OVScreenOrientationNone = 0,    // 不确定
    OVScreenOrientationVertical,    // 竖屏
    OVScreenOrientationHorizontal   // 横屏
};


typedef NS_ENUM(NSUInteger, OVScreenMode) {
    iPhone_5S_SE                 = 568,
    iPhone_6_6S_7_8              = 667,
    iPhone_6P_6SP_7P_8P          = 736,
    iPhone_12mini                = 780,
    iPhone_X_XS_11Pro            = 812,
    iPhone_12__12Pro             = 844,
    iPhone_XR_XSMax_11_11ProMax  = 896,
    iPhone_12ProMax              = 926,
};

@interface XMScreen : NSObject

// 返回指定屏幕的宽度
@property (nonatomic,assign) CGFloat width;

// 宽度相对于 6s 375的比例
@property (nonatomic,assign) CGFloat ratio;

// NavBar的高度
@property (nonatomic,assign) CGFloat navBarH;

// NavBar X增加的高度
@property (nonatomic,assign) CGFloat navBarAddH;

// nav Status的高度
@property (nonatomic,assign) CGFloat navStatusH;

// X 左边偏移位置
@property (nonatomic,assign) CGFloat mas_left;

@property (nonatomic,assign) CGFloat landscapeRight_MasLeft;

// tabBar的高度
@property (nonatomic,assign) CGFloat tabBarH;

// tabBar X增加的高度
@property (nonatomic,assign) CGFloat tabBarAddH;

// 横屏 竖屏
@property (nonatomic,assign) OVScreenOrientation orientation;

// 横屏 竖屏 比例
@property (nonatomic,assign) CGFloat orientationRatio;

@property (nonatomic,assign) OVScreenMode mode;

+ (instancetype)shared;

@end


NS_ASSUME_NONNULL_END
