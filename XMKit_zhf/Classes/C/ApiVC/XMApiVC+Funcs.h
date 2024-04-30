//
//  XMApiVC+Funcs.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/17.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMApiVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMApiVC (Funcs)

// 修改密码
- (void)resetPassWord:(NSString *)newPwd name:(NSString*)name state:(NSString *)state msg:(NSString *)msg;

// fb登录
- (void)fbLoginWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
