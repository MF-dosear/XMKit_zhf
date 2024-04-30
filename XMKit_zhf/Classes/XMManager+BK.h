//
//  XMManager+BK.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/14.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <XMKit_zhf/XMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMManager (YX)

/// 初始化回调
/// @param flag 是否成功
+ (void)sdkInitBack:(BOOL)flag;

/// 登录回调
/// @param flag 是否成功
+ (void)sdkLoginBack:(BOOL)flag;

/// 上传角色回调
/// @param flag 是否成功
+ (void)sdkSubmitRoleBack:(BOOL)flag;

/// 支付回调
/// @param flag 是否成功
+ (void)sdkPsyBack:(BOOL)flag;

/// 退出登录回调
/// @param flag 是否成功
+ (void)sdkLoginOutBack:(BOOL)flag;

/// 绑定回调
/// @param flag 是否成功
+ (void)sdkBindBack:(BOOL)flag;

/// 广告回调
+ (void)sdkShowReward:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
