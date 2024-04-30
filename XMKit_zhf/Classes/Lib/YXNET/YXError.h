//
//  YXError.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXError : NSObject

@property (nonatomic, assign) NSString *code;  // 错误码
@property (nonatomic, copy)   NSString *describe;  // 错误码解释

+ (instancetype)initWithCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END

/**
 
 // 域名
 static NSString *const YXNetAPI_Formal = @"http://imp.dailyfungame.com";
 static NSString *const YXNetAPI_Test   = @"http://imp.xmwconnect.com";

 // 初始化
 static NSString *const YXSDKInit            = @"sdk.game.initsdk";

 // 版本更新
 static NSString *const YXSDKUpdate          = @"sdk.info.versionUpdate";

 // 注册 并 登录
 static NSString *const YXSDKQuickLogin      = @"sdk.user.quickLogin";

 // 登录
 static NSString *const YXSDKLogin           = @"sdk.user.guestLogin" ;

 // 实名认证
 //static NSString *const YXSDKShiMingValidate = @"sdk.game.shimingvalidate";

 // 上传角色信息
 static NSString *const YXSDKEnter           = @"sdk.game.entergame";

 // 获取状态
 static NSString *const YXSDKState           = @"sdk.pay.getpaysort";

 // 获取订单号
 static NSString *const YXSDKOrder           = @"sdk.pay.fororder";

 // 苹果支付 2
 static NSString *const YXSDKApple          = @"sdk.pay.apple2";

 // 验证订单
 static NSString *const YXSDKQuery           = @"sdk.pay.query2";

 // 忘记密码
 static NSString *const YXSDKEditNewPwd      = @"sdk.user.updateNewPwd";

 // 三方登录登录
 static NSString *const YXSDKOtherLogin      = @"sdk.other.silentLogin";

 // 邮箱注册
 //static NSString *const YXSDKEmailLogin      = @"sdk.user.emailSignin";

 //邮箱验证码
 static NSString *const YXSDKEmailCode       = @"sdk.user.sendEmailCode";

 //邮箱绑定
 static NSString *const YXSDKBindEmail       = @"sdk.user.bindEmail";

 // 第三方绑定
 static NSString *const YXSDKBindOther       = @"sdk.other.silentLoginBind";

 //邮箱修改密码
 static NSString *const YXSDKEmailPWD        = @"sdk.user.updatePwdByEmail";

 // 推送token上报
 static NSString *const YXSDKUploadToken     = @"sdk.user.loginToken";
 
 **/
