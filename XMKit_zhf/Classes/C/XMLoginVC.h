//
//  XMLoginVC.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OVLoginMode) {
    OVLoginModeApple,
    OVLoginModeFacebook,
    OVLoginModeEmail,
};

@interface XMLoginVC : XMBaseVC

- (void)loginWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code mode:(OVLoginMode)mode;

@end

NS_ASSUME_NONNULL_END
