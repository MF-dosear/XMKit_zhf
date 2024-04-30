//
//  YXNet.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YXError.h"

typedef NS_ENUM(NSUInteger, YXNetMode) {
    YXNetModeGET,
    YXNetModePOST,
};

typedef void(^ResultBlock)(BOOL isSuccess, id _Nullable data, YXError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface YXNet : NSObject

/// sdk初始化
+ (void)sdkInit;

/// 更新
+ (void)checkVersion;

/// 自动登录
+ (void)autoLogin;

/// 展示登录框
+ (void)showLoginView;

/// 用户注册登录
+ (void)regiestAndLoginWithResult:(ResultBlock)result;

///// 邮箱注册
///// @param email 邮箱
///// @param code 验证码
///// @param result 返回结果
//+ (void)regiestWithEmail:(NSString *)email code:(NSString *)code result:(ResultBlock)result;

/// 登录
/// @param platform fb:3,apple:5,google:6
/// @param nickname nickname
/// @param openId openId
/// @param email email
/// @param token_for_business     token_for_business:fb必传
/// @param code 要绑定的账号
/// @param result 回调
+ (void)loginWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code result:(ResultBlock)result;

/// 登录
/// @param name 用户名
/// @param pwd 密码
/// @param result 结果
+ (void)loginWithName:(NSString *)name pwd:(NSString *)pwd result:(ResultBlock)result;

/// 获取验证码
/// @param email 邮箱
/// @param type 状态 找回密码：findpass 绑定邮箱：bindemail 登录：signin
/// @param result 结果
+ (void)getCodeWithEmail:(NSString *)email type:(NSString *)type result:(ResultBlock)result;

/// 找回密码
/// @param email 邮箱
/// @param code 验证码
/// @param name 用户名
/// @param pwd 密码
/// @param result 结果
+ (void)resetWithEmail:(NSString *)email code:(NSString *)code name:(NSString *)name pwd:(NSString *)pwd result:(ResultBlock)result;

/// 绑定邮箱
/// @param email 邮箱
/// @param code 验证码
/// @param result 结果
+ (void)bindWithEmail:(NSString *)email code:(NSString *)code result:(ResultBlock)result;

/// 绑定
/// @param platform fb:3,apple:5,google:6
/// @param nickname nickname
/// @param openId openId
/// @param email email
/// @param token_for_business     token_for_business:fb必传
/// @param code 要绑定的账号
+ (void)bindWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code result:(ResultBlock)result;

/// 上传角色信息
/// @param result 结果
+ (void)submitReloWithResult:(ResultBlock)result;

/// 获取psy信息
+ (void)psyState;

/// 获取订单号
/// @param channel 参数
/// @param name 标题
/// @param price 价格
/// @param result 结果
+ (void)getOrderWithChannel:(NSString *)channel name:(NSString *)name price:(NSString *)price result:(ResultBlock)result;

/// 苹果psy
/// @param orderID 单号
/// @param receipt 苹果回调数据
/// @param user 用户
/// @param cost 金额
/// @param tran_id 苹果订单id
/// @param isHUD 是否需要加载圈
/// @param result 结果
+ (void)applePsyWithOrderID:(NSString *)orderID receipt:(NSData *)receipt user:(NSString *)user cost:(NSString *)cost tran_id:(NSString *)tran_id isHUD:(BOOL)isHUD result:(ResultBlock)result;

/// 苹果登录
/// @param openId openId
/// @param result 结果
+ (void)appleLoginWithOpenId:(NSString *)openId result:(ResultBlock)result;

/// 上报推送token
/// @param token token
/// @param result 结果
+ (void)uploadFCMToken:(NSString *)token result:(ResultBlock)result;

/// 谷歌翻译
/// @param text 文本
/// @param lan 目标语言
/// @param result 翻译结果 isSucccess true成功 false失败
+ (void)trans:(NSString *)text lan:(NSString *)lan result:(void(^)(BOOL isSucccess, NSString *text))result;

@end

NS_ASSUME_NONNULL_END
