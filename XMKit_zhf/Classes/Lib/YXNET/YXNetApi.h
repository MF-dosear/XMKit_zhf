//
//  YXNetApi.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#ifndef YXNetApi_h
#define YXNetApi_h

// 域名
static NSString *const YXNetAPI_Formal = @"https://imp.bemadea.com";
static NSString *const YXNetAPI_Wap    = @"https://wap.bemadea.com";
static NSString *const YXNetAPI_Event  = @"https://receiver.bemadea.com";

static NSString *const Service_FbFans    = @"https://www.facebook.com/RoyalAffairs.zh/";
static NSString *const Service_Messenger = @"https://m.me/RoyalAffairs.zh";
static NSString *const Service_Email     = @"playmakersinteractive@gmail.com";
static NSString *const Service_server    = @"https://www.bemadea.com/service.html?platform=ios&game=1000088";

// 初始化
static NSString *const YXSDKInit            = @"sdk.dungeons.initsdk";

// 版本更新
static NSString *const YXSDKUpdate          = @"sdk.dungeons.versionUpdate";

// 注册 并 登录
static NSString *const YXSDKQuickLogin      = @"sdk.dungeons.quickLogin";

// 登录
static NSString *const YXSDKLogin           = @"sdk.dungeons.guestLogin" ;

// 实名认证
//static NSString *const YXSDKShiMingValidate = @"sdk.dungeons.shimingvalidate";

// 上传角色信息
static NSString *const YXSDKEnter           = @"sdk.dungeons.entergame";

// 获取状态
static NSString *const YXSDKState           = @"sdk.dungeons.getpaysort";

// 获取订单号
static NSString *const YXSDKOrder           = @"sdk.dungeons.fororder";

// 苹果支付 2
static NSString *const YXSDKApple           = @"sdk.dungeons.apple";

// 验证订单
static NSString *const YXSDKQuery           = @"sdk.dungeons.query2";

// 忘记密码
static NSString *const YXSDKEditNewPwd      = @"sdk.dungeons.updateNewPwd";

// 三方登录登录
static NSString *const YXSDKOtherLogin      = @"sdk.dungeons.silentLogin";

// 邮箱注册
//static NSString *const YXSDKEmailLogin      = @"sdk.dungeons.emailSignin";

//邮箱验证码
static NSString *const YXSDKEmailCode       = @"sdk.dungeons.sendEmailCode";

//邮箱绑定
static NSString *const YXSDKBindEmail       = @"sdk.dungeons.bindEmail";

// 第三方绑定
static NSString *const YXSDKBindOther       = @"sdk.dungeons.silentLoginBind";

//邮箱修改密码
static NSString *const YXSDKEmailPWD        = @"sdk.dungeons.updatePwdByEmail";

// 推送token上报
static NSString *const YXSDKUploadToken     = @"sdk.dungeons.loginToken";

#endif /* YXNetApi_h */


/**
 

 
 **/
