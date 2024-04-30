//
//  UIAlertController+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/19.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (YX)

+ (void)alertTitle:(NSString *)title msg:(NSString *)msg handler:(void (^)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
