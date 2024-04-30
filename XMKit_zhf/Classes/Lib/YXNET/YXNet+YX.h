//
//  YXNet+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "YXNet.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EventMode) {
    EventMode_active_start = 0, //(SDK的初始化接口请求开始)
    EventMode_active_success, // (SDK的初始化接口请求成功)
    EventMode_register_success, // (SDK的注册成功)
    EventMode_login_success, // (SDK登录成功)
    EventMode_accountlogin_show, // (SDK账号密码登录界面展示)
    EventMode_phonereg_show, // (SDK手机号密码注册界面展示)
    EventMode_phonelogin_show, // (SDK手机号验证码登录界面展示)
    EventMode_quickreg_show, // (SDK快速注册界面展示)
    EventMode_geelogin_show, // (SDK极验登录界面展示)
    EventMode_realname_show, // (SDK实名界面展示)
    EventMode_realname_commit, // (SDK点击提交实名认证)
    EventMode_realname_success, // (SDK实名成功)
};

@interface YXNet (YX)

/**
 GET 请求
 
 @param url api地址
 @param params 请求参数
 @param result 返回结果
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result;

/**
 POST 请求
 
 @param url api地址
 @param params 请求参数
 @param result 返回结果
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result;

/**
 GET 请求
 
 @param url api地址
 @param params 请求参数
 @param result 返回结果
 */
+ (void)hudGetWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result;

/**
 POST 请求
 
 @param url api地址
 @param params 请求参数
 @param result 返回结果
 */
+ (void)hudPostWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result;

/// 获取sign
/// @param url 连接
/// @param info 信息
+ (NSString *)signWithUrl:(NSString *)url appid:(NSString *)appid appkey:(NSString *)appkey info:(NSDictionary *)info;

///// 苹果psy
///// @param orderID 单号
///// @param receipt 苹果回调数据
///// @param user 用户
///// @param cost 金额
///// @param tran_id 苹果订单id
///// @param result 结果
//+ (void)apple2PsyWithOrderID:(NSString *)orderID receipt:(NSData *)receipt user:(NSString *)user cost:(NSString *)cost tran_id:(NSString *)tran_id result:(ResultBlock)result;

/// 上传bug反馈
/// @param bug bug
/// @param result result
+ (void)uploadBugInfo:(NSString *)bug result:(ResultBlock)result;

/// 热修复
/// @param result 热修复
+ (void)hotfixListWithAppleID:(NSString *)appleID result:(ResultBlock)result;

// 事件上报
+ (void)uploadEvent:(NSString *)event play_session:(NSString *)play_session properties:(NSString *)properties;

/// 上报事件
/// @param mode 事件名
+ (void)uploadEventMode:(EventMode)mode;

/// 心跳上报
+ (void)head;

///// 防沉迷
//+ (void)heartWithHeartMode:(FxHEARTMode)mode result:(ResultBlock)result;

@end

NS_ASSUME_NONNULL_END
