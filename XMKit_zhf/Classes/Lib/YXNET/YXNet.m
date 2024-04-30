//
//  YXNet.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "YXNet.h"

#import "YXNet+YX.h"
#import "YXNetApi.h"

#import <XMKit_zhf/XMInfos.h>
#import "XMConfig.h"
#import "XMManager+BK.h"
#import "XMManager+Apple.h"

#import "XMUpgradeVC.h"
#import "XMApiVC.h"
#import "YXStatis.h"
#import "XMLoginVC.h"

#import "XMInfos.h"

@implementation YXNet

/// 检测更新
+ (void)checkVersion{
    NSString *verson = [APPVERSION stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:verson key:@"api_gameversion"];
    [YXNet postWithURL:YXSDKUpdate params:params result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            // 是否展示更新页面
            NSString *href = data[@"url"];
            if ([href hasPrefix:@"http"]) {
                
                XMUpgradeVC *vc = [[XMUpgradeVC alloc] init];
                vc.url = href;
                [vc present];
            } else {
                // 初始化SDK
                [YXNet sdkInit];
            }
        } else {
            // 初始化失败
            [XMManager sdkInitBack:false];
        }
    }];
}

/// 初始化
+ (void)sdkInit{
    
    [YXNet uploadEventMode:EventMode_active_start];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:GMChannel key:@"channel"];
    [params addValue:DEV_IDFA  key:@"udid"];
    
    [YXNet postWithURL:YXSDKInit params:params result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess == false) {
            // 超时 默认成功
            [XMManager sdkInitBack:true];
        } else {
            YXLog(@"info = %@",data);
            XMConfig *config = [XMConfig sharedXMConfig];
            
            config.apple_isopen = [data[@"apple_isopen"] boolValue];
            config.bf_time = [data[@"bf_time"] integerValue];
            config.fb_isopen = [data[@"fb_isopen"] boolValue];
            
            config.gameName = data[@"gameName"];
            config.is_open_smrz = [data[@"is_open_smrz"] boolValue];
            config.is_open_yange = [data[@"is_open_yange"] boolValue];
            
            config.is_user_protocol = [data[@"is_user_protocol"] boolValue];
            config.smrz_show_close_button = [data[@"smrz_show_close_button"] boolValue];
            config.tel = data[@"tel"];
            
            config.user_protocol = data[@"user_protocol"];
            config.user_private = data[@"user_private"];
            config.work_url = data[@"work_url"];
            
            config.fbmsg = data[@"fbmsg"];
            config.fbfans = data[@"fbfans"];
            config.emails = data[@"email"];
            
            // 初始化成功
            [XMManager sdkInitBack:true];
            
            [YXNet uploadEventMode:EventMode_active_success];
        }
    }];
}

/// 自动登录
+ (void)autoLogin{
    
    XMConfig *config = [XMConfig sharedXMConfig];
    NSDictionary *info = [config users].firstObject;
    
    if (info) {
        NSString *username = info[TableLeak_username];
        NSString *password = info[TableLeak_pwd];
        
        // 自动登录
        [YXNet loginWithName:username pwd:password];
    } else {
        // 快速注册登录
        
        [YXNet regiestAndLoginWithResult:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
            
            if (isSuccess) {
                
                // 存储登录数据
                XMConfig *config = [XMConfig sharedXMConfig];
                config.uid       = data[@"uid"];
                config.sid       = data[@"sid"];
                config.user_name = data[@"user_name"];
                config.log_name  = data[@"user_name"];
                config.pwd       = data[@"password"];
                
                // 登录
                [YXNet loginWithName:config.log_name pwd:config.pwd];
                
                [YXStatis userRegistration:@"autoRegiestLogin"];
                
                // 注册成功统计
                [YXNet uploadEventMode:EventMode_register_success];
            } else {
                
                [YXHUD checkError:error completion:^{
                    // 弹出登录框
                    [YXNet showLoginView];
                }];
            }
        }];
    }
}

/// 账号密码登录
+ (void)loginWithName:(NSString *)name pwd:(NSString *)pwd{
    
    [YXNet loginWithName:name pwd:pwd result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            // 登录成功
            [XMManager sdkLoginBack:true];
        } else {
            // 弹出登录框
            [YXNet showLoginView];
        }
    }];
}

/// 展示登录框
+ (void)showLoginView{
    
    [YXStatis uploadAction:statis_login_ui_show];
    
    XMLoginVC *vc = [[XMLoginVC alloc] init];
    [vc present];
}

/// 用户注册登录
+ (void)regiestAndLoginWithResult:(ResultBlock)result{
    [YXNet hudPostWithURL:YXSDKQuickLogin params:@{} result:result];
}

//+ (void)regiestWithEmail:(NSString *)email code:(NSString *)code result:(ResultBlock)result{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params addValue:email              key:@"username"];
//    [params addValue:code               key:@"code"];
//    [params addValue:GMChannel          key:@"channel"];
//    [params addValue:DEV_IDFA           key:@"udid"];
//    [YXNet hudPostWithURL:YXSDKEmailLogin params:params result:result];
//}

/// 登录
/// @param platform fb:3,apple:6
/// @param nickname nickname
/// @param openId openId
/// @param email email
/// @param token_for_business     token_for_business:fb必传
/// @param code 要绑定的账号
/// @param result 回调
+ (void)loginWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code result:(ResultBlock)result{

    XMConfig *config = [XMConfig sharedXMConfig];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:@(platform)        key:@"platform"];
    [params addValue:nickname           key:@"nickname"];
    [params addValue:config.user_name   key:@"username"];

    [params addValue:openId      key:@"openId"];
    [params addValue:email       key:@"email"];
    [params addValue:code        key:@"code"];

    [params addValue:token_for_business key:@"token_for_business"];

    [YXNet hudPostWithURL:YXSDKOtherLogin params:params result:result];
}

/// 登录
/// @param name 用户名
/// @param pwd 密码
/// @param result 结果
+ (void)loginWithName:(NSString *)name pwd:(NSString *)pwd result:(ResultBlock)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:name               key:@"username"];
    [params addValue:[pwd jk_md5String] key:@"passwd"];
    [params addValue:pwd                key:@"passwdMW"];
    
    [YXStatis uploadAction:statis_login_request_start];
    
    [YXNet hudPostWithURL:YXSDKLogin params:params result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess == false) {
            // 登录失败
            [YXHUD showErrorWithText:error.describe completion:^{
                
                [XMManager sdkLoginBack:false];
            }];
        } else {
            
            [YXStatis uploadAction:statis_login_request_suc];
            
            // 解析数据
            XMConfig *config = [XMConfig sharedXMConfig];
            
            config.adult     = [data[@"adult"] integerValue];
            config.buoyState = data[@"buoyState"];
            config.drurl     = [data[@"drurl"] integerValue];

            config.email        = data[@"email"];
            config.idCard       = data[@"idCard"];
            config.isBindMobile = [data[@"isBindMobile"] boolValue];
            
            config.isOldUser    = [data[@"isOldUser"] boolValue];
            config.is_smrz      = [data[@"is_smrz"] boolValue];
            config.isbindemail  = [data[@"isbindemail"] integerValue];
            
            config.isguest      = [data[@"isguest"] boolValue];
            config.isnew        = [data[@"isnew"] boolValue];
            config.login_days   = [data[@"login_days"] integerValue];
            
            config.mobile    = data[@"mobile"];
            config.nick_name = data[@"nick_name"];
            config.profile   = data[@"profile"];
            
            
            config.sid            = data[@"sid"];
            config.trueName       = data[@"trueName"];
            config.trueNameSwitch = [data[@"trueNameSwitch"] boolValue];
            
            config.uid          = data[@"uid"];
            config.userSex      = [data[@"userSex"] integerValue];
            
            config.isBindFb     = [data[@"isBindFb"] boolValue];
            config.isBindApple  = [data[@"isBindApple"] boolValue];
            config.isBindEmail  = [data[@"isBindEmail"] boolValue];
            
            config.user_name    = data[@"user_name"];
            config.log_name     = name;
            config.pwd          = pwd;

            if (config.login_days == 1) {
                [YXStatis userLogin:YXStatisModeSecond];
            }else if (config.login_days == 3) {
                [YXStatis userLogin:YXStatisModeThree];
            }else if (config.login_days == 7) {
                [YXStatis userLogin:YXStatisModeSeven];
            }else if (config.login_days == 14) {
                [YXStatis userLogin:YXStatisModeFourteen];
            }else if (config.login_days == 30) {
                [YXStatis userLogin:YXStatisModeMonth];
            }
            
            // 登录成功提示
            [YXHUD showSuccessWithText:LocalizedString(@"Login successful")];
        }
        
        result(isSuccess,data,error);
    }];
}

///// 检测是否需要绑定邮箱
//+ (void)checkBingEmail{
//    // 检测是否需要绑定邮箱
//    XMConfig *config = [XMConfig sharedXMConfig];
//    if (config.email.length > 0) {
//        // 不需要绑定，登录成功
//        [XMManager sdkLoginBack:true];
//    } else {
//        // 是否今日不再提醒
//        NSString *bindKey = [NSString stringWithFormat:@"%@%@",BindRemindPrefix,config.user_name];
//        NSDictionary *info = [NSUserDefaults objectForKey:bindKey];
//        NSString *key = [NSDate jk_formatYMD:[NSDate date]];
//        BOOL isRemind = [info[key] boolValue];
//        if (isRemind) {
//            // 不需要绑定，登录成功
//            [XMManager sdkLoginBack:true];
//        } else {
//            // 前去 绑定
//            OVRemindVC *vc = [[OVRemindVC alloc] init];
//            [vc present];
//        }
//    }
//}

/// 获取验证码
/// @param email 邮箱
/// @param type 状态 找回密码：findpass 绑定邮箱：bindemail 登录：signin
/// @param result 结果
+ (void)getCodeWithEmail:(NSString *)email type:(NSString *)type result:(ResultBlock)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:email key:@"email"];
    [params addValue:type  key:@"type"];
    [YXNet hudPostWithURL:YXSDKEmailCode params:params result:result];
}

/// 绑定邮箱
/// @param email 邮箱
/// @param code 验证码
/// @param result 结果
+ (void)bindWithEmail:(NSString *)email code:(NSString *)code result:(ResultBlock)result{
    
    XMConfig *config = [XMConfig sharedXMConfig];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:email              key:@"email"];
    [params addValue:code               key:@"code"];
    [params addValue:config.user_name   key:@"username"];

    [params addValue:config.uid         key:@"userid"];
    
    [YXNet hudPostWithURL:YXSDKBindEmail params:params result:result];
}

/// 绑定
/// @param platform fb:3,apple:5,google:6
/// @param nickname nickname
/// @param openId openId
/// @param email email
/// @param token_for_business     token_for_business:fb必传
/// @param code 要绑定的账号
+ (void)bindWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code result:(ResultBlock)result{
    
    XMConfig *config = [XMConfig sharedXMConfig];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:@(platform)        key:@"platform"];
    [params addValue:nickname           key:@"nickname"];
    [params addValue:config.user_name   key:@"username"];

    [params addValue:openId      key:@"openId"];
    [params addValue:email       key:@"email"];
    [params addValue:code        key:@"code"];

    [params addValue:token_for_business key:@"token_for_business"];
    
    [YXNet hudPostWithURL:YXSDKBindOther params:params result:result];
}

/// 找回密码
/// @param email 邮箱
/// @param code 验证码
/// @param name 用户名
/// @param pwd 密码
/// @param result 结果
+ (void)resetWithEmail:(NSString *)email code:(NSString *)code name:(NSString *)name pwd:(NSString *)pwd result:(ResultBlock)result{
    
    NSString *pwd_md5 = [pwd jk_md5String];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:email   key:@"email"];
    [params addValue:name    key:@"username"];
    [params addValue:code    key:@"code"];
    [params addValue:pwd_md5 key:@"passwd"];
    [params addValue:pwd     key:@"passwdMW"];
    [YXNet hudPostWithURL:YXSDKEmailPWD params:params result:result];
}

/// 上传角色信息
/// @param result 结果
+ (void)submitReloWithResult:(ResultBlock)result{
    
    XMInfos *info = [XMInfos sharedXMInfos];
    XMConfig *config = [XMConfig sharedXMConfig];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:config.uid       key:@"uid"];
    [params addValue:config.user_name key:@"username"];
    
    [params addValue:info.serverID   key:@"serverId"];
    [params addValue:info.serverName key:@"serverName"];
    [params addValue:info.roleID     key:@"roleID"];
    
    [params addValue:info.roleName   key:@"roleName"];
    [params addValue:info.roleLevel  key:@"roleLevel"];
    [params addValue:info.psyLevel   key:@"payLevel"];
    [params addValue:DEV_IDFA        key:@"udid"];
    [YXNet postWithURL:YXSDKEnter params:params result:result];
}

/// 获取psy状态
+ (void)psyState{
    
    XMInfos *info = [XMInfos sharedXMInfos];
    
    [YXNet getOrderWithChannel:@"" name:@"" price:info.price result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
    
        if (isSuccess) {
            
            XMConfig *config = [XMConfig sharedXMConfig];
            config.orderID = data[@"order_id"];
            // 支付
            [XMManager toPsyWithProductId:info.goodsID];
        } else {
            // 支付失败
            [YXHUD showErrorWithText:error.describe completion:^{
                [XMManager sdkPsyBack:false];
            }];
        }
    }];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params addValue:info.roleLevel   key:@"roleLevel"];
//    [params addValue:config.user_name key:@"username"];
//
//    [YXNet hudPostWithURL:YXSDKState params:params result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
//
//        if (isSuccess) {
//
//            config.psy_state = [data[@"payState"] integerValue];
//            if (config.psy_state == 1) {
//
//                [YXNet getOrderWithChannel:@"" name:@"" price:info.price result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
//
//                    if (isSuccess) {
//
//                        config.orderID = data[@"order_id"];
//                        // 支付
//                        [XMManager toPsyWithProductId:info.goodsID];
//                    } else {
//                        // 支付失败
//                        [YXHUD showErrorWithText:error.describe completion:^{
//                            [XMManager sdkPsyBack:false];
//                        }];
//                    }
//                }];
//            } else if (config.psy_state == 2){
//                XMApiVC *vc = [[XMApiVC alloc] init];
//                vc.isNavBarHidden = true;
//                vc.isClear = true;
//                vc.api = [NSString stringWithFormat:@"http://www.bekinggame.com/overseaPay/index.html?amount=%@&lang=%@&appid=%@",info.price,[UIDevice language],info.AppID];
//                [vc present];
//            }
//        } else {
//            // 支付失败
//            [YXHUD showErrorWithText:error.describe completion:^{
//                [XMManager sdkPsyBack:false];
//            }];
//        }
//    }];
}

/// 获取订单号
+ (void)getOrderWithChannel:(NSString *)channel name:(NSString *)name price:(NSString *)price result:(ResultBlock)result{
    
    XMConfig *config = [XMConfig sharedXMConfig];
    XMInfos *infos = [XMInfos sharedXMInfos];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addValue:config.user_name key:@"username"];
    [params addValue:price            key:@"cost"];
    [params addValue:infos.cpOrder    key:@"cpOrder"];
    
    [params addValue:infos.goodsID    key:@"goodsID"];
    [params addValue:infos.serverID   key:@"serverId"];
    [params addValue:infos.serverName key:@"serverName"];
    
    [params addValue:infos.goodsName  key:@"goodsName"];
    [params addValue:infos.roleID     key:@"roleID"];
    [params addValue:infos.roleName   key:@"roleName"];
    
    [params addValue:infos.roleLevel  key:@"roleLevel"];
    [params addValue:infos.extends    key:@"extends"];
    [params addValue:DEV_IDFA         key:@"udid"];
    
    [params addValue:infos.notify     key:@"notifyURL"];
    [params addValue:channel          key:@"payChannel"];
    
    [YXNet hudPostWithURL:YXSDKOrder params:params result:result];
}

+ (void)applePsyWithOrderID:(NSString *)orderID receipt:(NSData *)receipt user:(NSString *)user cost:(NSString *)cost tran_id:(NSString *)tran_id isHUD:(BOOL)isHUD result:(ResultBlock)result{
    
    NSString *rec_text = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params addValue:orderID   key:@"orderid"];
    [params addValue:user      key:@"username"];
    [params addValue:rec_text  key:@"receipt_data"];
    [params addValue:tran_id   key:@"transaction_id"];
    [params addValue:cost      key:@"cost"];
    
    if (isHUD) {
        [YXNet hudPostWithURL:YXSDKApple params:params result:result];
    } else {
        [YXNet postWithURL:YXSDKApple params:params result:result];
    }
}

+ (void)appleLoginWithOpenId:(NSString *)openId result:(ResultBlock)result{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params addValue:openId   key:@"openId"];
    [params addValue:@"5"     key:@"platform"];
    
    [YXNet postWithURL:YXSDKOtherLogin params:params result:result];
}

+ (void)uploadFCMToken:(NSString *)token result:(ResultBlock)result{
    
    if (token.length <= 0) {
        return;
    }
    
    XMConfig *config = [XMConfig sharedXMConfig];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:config.user_name key:@"username"];
    [params addValue:config.uid       key:@"uId"];
    [params addValue:token            key:@"token"];
    
    [YXNet postWithURL:YXSDKUploadToken params:params result:result];
}

+ (void)trans:(NSString *)text lan:(NSString *)lan result:(void(^)(BOOL isSucccess, NSString *text))result{
    
    NSString *language = lan.length == 0 ? @"en" : lan;
    
    XMInfos *infos = [XMInfos sharedXMInfos];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data addValue:text        key:@"text"];
    [data addValue:language    key:@"targetLanguage"];
    [data addValue:infos.AppID key:@"gameid"];
    
    NSString *data_json = [data jk_JSONString];
    NSDictionary *info = @{@"data":data_json};

    NSString *url_str = [NSString stringWithFormat:@"%@/google/googleTranslate.php",YXNetAPI_Wap];
    NSURL *url = [NSURL URLWithString:url_str];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[YXNet bodyWithInfo:info] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *cf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableDictionary *cf_hd = [NSMutableDictionary dictionary];
    cf.HTTPAdditionalHeaders = cf_hd;
    
    // 3.采用苹果提供的共享session
    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:cf];
    
    // 4.由系统直接返回一个dataTask任务
    // 网络请求完成之后completionHandler就会执行，NSURLSession自动实现多线程
    NSURLSessionDataTask * dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 主线程返回
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                result(false,nil);
            } else{
                
                NSError *error;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    result(false,nil);
                } else {
                    NSInteger code = [dict[@"state"][@"code"] integerValue];
                    if (code == 1) {
                        result(true,dict[@"data"]);
                    } else{
                        result(false,nil);
                    }
                }
            }
        });
    }];
    
    // 5.每一个任务默认都是挂起的，需n要调用 resume 方法
    [dataTask resume];
}

+ (NSString *)bodyWithInfo:(NSDictionary *)parameter{
    
    NSString *jsonStr = @"";
    if (!parameter || ![parameter isKindOfClass:[NSDictionary class]]) {
        return jsonStr;
    }
    NSArray  *arrKeys = [parameter allKeys];
    for (int i = 0 ; i < arrKeys.count ; i++)
    {
        NSString * key   = arrKeys[i];
        NSString * value = [parameter valueForKey:key];
        if (i+1 == arrKeys.count) {
            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[YXNet fmq_encodeValue:value]]];
        } else {
            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[YXNet fmq_encodeValue:value]]];
        }
    }
    return jsonStr;
}

#pragma mark - 特殊字符处理
+ (NSString *)fmq_encodeValue:(NSString *)string{
    
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "] invertedSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

@end
