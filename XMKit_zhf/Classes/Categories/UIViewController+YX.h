//
//  UIViewController+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/14.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YX)

/// 展示当前视图
- (void)present;

- (void)push:(UIViewController *)vc;

- (void)pop;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
