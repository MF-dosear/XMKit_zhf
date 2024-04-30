//
//  XMBindAccountVC+Apple.h
//  XMSDK
//
//  Created by dosear on 2021/8/2.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindAccountVC.h"

#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMBindAccountVC (Apple)<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

/// apple 绑定
- (void)bindApple;

@end

NS_ASSUME_NONNULL_END
