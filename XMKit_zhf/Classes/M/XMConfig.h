//
//  YXAPP.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMKit_zhf/Singleton.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const OROrderID     = @"user_order_id";
static NSString *const ORUserName    = @"user";
static NSString *const ORPrice       = @"cost";
static NSString *const ORGoodName    = @"goodName";
static NSString *const ORReceiptData = @"receipt_data";
static NSString *const ORDate        = @"date";

static NSString *const OROrderCache  = @"OROrderCache";

@interface XMConfig : NSObject
singleton_interface(XMConfig)

/// 登录数据 用户信息
@property (nonatomic, assign) NSInteger adult;  // 是否成年人
@property (nonatomic, assign) NSInteger drurl;
@property (nonatomic, copy) NSString *buoyState; // 是否开启悬浮框

@property (nonatomic, copy) NSString *email; // 邮箱
@property (nonatomic, copy) NSString *idCard; // 身份证
@property (nonatomic, assign) BOOL isBindMobile; // 是否绑定手机号

@property (nonatomic, assign) BOOL isOldUser; // 是否是老用户
@property (nonatomic, assign) BOOL is_smrz; // 是否实名认证成功
@property (nonatomic, assign) BOOL isbindemail; // 是否绑定邮件

@property (nonatomic, assign) BOOL isguest;
@property (nonatomic, assign) BOOL isnew; // 是否新用户
@property (nonatomic, assign) NSInteger login_days;  // 登录天数

@property (nonatomic, copy) NSString *mobile; // 手机号
@property (nonatomic, copy) NSString *nick_name; // 昵称
@property (nonatomic, copy) NSString *profile; // 简介

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, assign) BOOL trueNameSwitch; // 真实姓名

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) NSInteger userSex;  // 性别
@property (nonatomic, assign) NSInteger age;  // 年龄

// 账号密码
@property (nonatomic, copy) NSString *log_name; // 登录用户名
@property (nonatomic, copy) NSString *user_name;  // 用户名
@property (nonatomic, copy) NSString *pwd;

/***************以上是登录数据 划线*****************/

/// 其他信息
@property (nonatomic, assign) BOOL apple_isopen; // 是否苹果登录
@property (nonatomic, assign) NSInteger bf_time; // 补发时间
@property (nonatomic, assign) BOOL fb_isopen;    // 是否开启fb登录

@property (nonatomic, copy)   NSString *gameName;
@property (nonatomic, assign) BOOL is_open_smrz; // 是否开启实名认证
@property (nonatomic, assign) BOOL is_open_yange; // 严格实名认证

@property (nonatomic, assign) BOOL is_user_protocol; // 是否开启协议
@property (nonatomic, assign) BOOL smrz_show_close_button; // 实名认证关闭按钮

@property (nonatomic, copy) NSString *tel; // 电话
@property (nonatomic, copy) NSString *user_private; // 隐私
@property (nonatomic, copy) NSString *user_protocol; // 协议

@property (nonatomic, copy) NSString *work_url; // 协议
@property (nonatomic, copy) NSString *fbmsg; // fb massager
@property (nonatomic, copy) NSString *fbfans; // fb粉丝页
@property (nonatomic, copy) NSString *emails; // email

/***************以上是初始化数据 划线*****************/

@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *user_pass;

/// 是否绑定fb
@property (nonatomic, assign) BOOL isBindFb;
/// 是否绑定apple
@property (nonatomic, assign) BOOL isBindApple;
/// 是否绑定邮箱
@property (nonatomic, assign) BOOL isBindEmail;

/// sdk 订单信息
@property (nonatomic, assign) NSInteger psy_state;
@property (nonatomic, copy)   NSString *orderID;
@property (nonatomic, copy)   NSString *goodbye;

// 其他信息
@property (nonatomic, assign) BOOL isInit;  // 是否初始化
@property (nonatomic, assign) BOOL isLogin; // 是否登录

@property (nonatomic, copy)   NSString *FCMToken; // FCMToken


#pragma mark -- 用户缓存
/// 存登录用户
- (void)saveUser;

/// 获取用户列表
- (NSArray *)users;

/// 移除用户
/// @param name 用户名
- (void)removeWithName:(NSString *)name;

/// 查询用户
/// @param name 用户名
- (NSDictionary *)userWithName:(NSString *)name;

// 移除所有信息
- (void)removeAllInfo;

@end

NS_ASSUME_NONNULL_END
