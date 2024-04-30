//
//  XMNavVC.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXNavMode) {
    YXNavModeNormal,
    YXNavModeInfo,
    YXNavModeService
};

@interface XMNavVC : UINavigationController

@property (nonatomic, assign) YXNavMode mode;

@end

NS_ASSUME_NONNULL_END
