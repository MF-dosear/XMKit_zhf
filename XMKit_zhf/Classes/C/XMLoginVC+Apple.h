//
//  XMLoginVC+Apple.h
//  XMSDK
//
//  Created by dosear on 2021/7/31.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMLoginVC.h"

#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMLoginVC (Apple)<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

/// apple 登录
- (void)appleLogin;

@end

NS_ASSUME_NONNULL_END
