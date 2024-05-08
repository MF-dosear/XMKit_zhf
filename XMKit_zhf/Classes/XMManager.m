//
//  XMManager.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMManager.h"

#import "XMManager+BK.h"

#import "XMNavVC.h"

#import <XMKit_zhf/XMInfos.h>
#import "XMConfig.h"
#import "YXAuxView.h"
#import "AvoidCrash.h"
#import "YXNet+YX.h"
#import "LYFix.h"
#import "XMServiceVC.h"
#import "XMBindAccountVC.h"

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import "YXStatis.h"
#import <UserNotifications/UserNotifications.h>

#import "XMServiceApiVC.h"

#import "XMManager+Ad.h"
#import <AppLovinSDK/AppLovinSDK.h>

#import "XMManager+DeepLink.h"

@interface XMManager ()<UNUserNotificationCenterDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@property (nonatomic, assign ,readwrite) id<XMDelegate> delegate;

@property (nonatomic, copy, readwrite) XMDeepLinkBlock deeplinkBlock;

@end

static NSString *const YXBUGCache  = @"YXBUGCache";

NSString *const kGCMMessageIDKey = @"gcm.message_id";

@implementation XMManager
singleton_implementation(XMManager)

/// 初始化
/// @param delegate 代理
+ (void)sdkInitWithDelegate:(id<XMDelegate>)delegate{
    
    if (delegate == nil) {
        YXLog(@"参数delegate为nil，初始化失败");
        return;
    }
    
    // 禁用键盘调整
    [[IQKeyboardManager sharedManager] setEnable:false];
    
    // 设置代理
    [XMManager sharedXMManager].delegate = delegate;
    
    // hud风格设置
    [XMManager hudStyle];
    
    // 激活开始
    [YXStatis uploadAction:statis_active_start];
    
    // 检测更新->初始化
    [YXNet checkVersion];
    
    // 悬浮框实例化
    [YXAuxView sharedAux];
}

/// 提示框风格
+ (void)hudStyle{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

/// 登录
+ (void)sdkLoginWithAutomatic:(BOOL)automatic{
    
    XMConfig *config = [XMConfig sharedXMConfig];
    if (config.isInit == false) {

        // 初始化SDK
        [YXNet sdkInit];
        return;
    }
    
    [YXStatis uploadAction:statis_game_start_login];
    
    if (config.isLogin) {
        // 登录结果回调
        XMManager *manager = [XMManager sharedXMManager];
        if ([manager.delegate respondsToSelector:@selector(sdkLoginResult:userID:userName:session:isBind:)]) {
            
            BOOL isBind = config.isbindemail || config.isBindApple || config.isBindFb;
            [manager.delegate sdkLoginResult:true userID:config.uid userName:config.user_name session:config.sid isBind:isBind];
        } else {
            YXLog(@"sdkLoginResult回调未实现");
        }
        return;
    }
    
    // 第一次 自动登录
    BOOL first_login = [[NSUserDefaults objectForKey:@"first_login"] boolValue];
    if (first_login == false) {
        
        [YXNet autoLogin];
        [NSUserDefaults addValue:@(true) key:@"first_login"];
        return;
    }
    
    BOOL isAuto = [[NSUserDefaults objectForKey:YXAutoLoginCache] boolValue];
    if (automatic && isAuto){
        // 自动登录
        [YXNet autoLogin];
    } else {
        // 弹出登录框
        [YXNet showLoginView];
    }
}

/// 上传角色信息
/// @param info info
+ (void)sdkSubmitRole:(XMInfos *)info{
    
    if (info == nil) {
        YXLog(@"参数info为nil，初始化失败");
        return;
    }
    
    XMConfig *config = [XMConfig sharedXMConfig];
    if (config.isInit == false) {
        [YXHUD showErrorWithText:LocalizedString(@"Init Repeat")];
        return;
    }
    
    if (config.isLogin == false) {
        [YXHUD showInfoWithText:LocalizedString(@"UnLogin")];
        return;
    }
    
    [YXNet submitReloWithResult:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        [XMManager sdkSubmitRoleBack:isSuccess];
    }];
}

/// zhi付
/// @param info 订单信息
+ (void)sdkPsy:(XMInfos *)info{
    
    [YXNet psyState];
}

/// 退出登录
+ (void)sdkLoginOutBackFlag:(BOOL)flag{
    [XMManager sdkLoginOutBack:flag];
}

+ (void)sdkApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions deeplinkBlock:(XMDeepLinkBlock)deeplinkBlock{
    
    [XMManager sharedXMManager].deeplinkBlock = deeplinkBlock;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([XMManager sharedXMManager].isDeeplinkBack == false) {
            [XMManager sharedXMManager].deeplinkBlock(false, nil, nil);
        }
    });
    
    XMInfos *infos = [XMInfos sharedXMInfos];
    
    // 奔溃预防
    [XMManager avoidCrash];
    
    // sdk热修复
    [XMManager hotfixWithAppleID:infos.AppleID];

    //初始化AppsFlyer
    [AppsFlyerLib shared].appsFlyerDevKey = infos.appsFlyerKey;
    [AppsFlyerLib shared].appleAppID = infos.AppleID;
    [AppsFlyerLib shared].isDebug = YXDebug;
    
    // facebook初始化
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:nil];
    
    // firebase初始化
    [FIRApp configure];
    
    // firebase推送
    [FIRMessaging messaging].delegate = instance;
    
    // iOS 10 or later
    // For iOS 10 display notification (sent via APNS)
    [UNUserNotificationCenter currentNotificationCenter].delegate = instance;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter]
        requestAuthorizationWithOptions:authOptions
        completionHandler:^(BOOL granted, NSError * _Nullable error) {
          // ...
        }];

    [application registerForRemoteNotifications];
    
    // AppLovin广告初始化
    if (infos.rewardedAdID.length != 0){
        
        // Create the initialization configuration
        ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey:infos.AppLovinSdkKey builderBlock:^(ALSdkInitializationConfigurationBuilder * _Nonnull builder) {
            
            
            builder.mediationProvider = ALMediationProviderMAX;
        }];
        
        [[ALSdk shared] initializeWithConfiguration:initConfig completionHandler:^(ALSdkConfiguration * _Nonnull configuration) {
            
            // AppLovin SDK已初始化，开始加载广告
//            if (@available(iOS 14.5, *)){
//                // 请注意，可以通过`sdkConfiguration.appTrackingTransparencyStatus检查应用程序透明度跟踪授权`
//                // 1.在此处设置Meta ATE标志，然后
//            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[XMManager sharedXMManager] loadRewardedAd];
            });
        }];
        
        // 要在代码中禁用广告素材调试器，请设置creativeDebuggerEnabled至NO或者false：
        [ALSdk shared].settings.creativeDebuggerEnabled = false;
        
        // 如果您不想启用受限数据使用 (LDU) 模式，请通过SetDataProcessingOptions()一个空数组：
        [FBAdSettings setDataProcessingOptions: @[]];
    }
    
    // Deeplink
    [XMManager deepLinkApplication:application didFinishLaunchingWithOptions:launchOptions];
    
//    NSString *version = [ALSdk version];
//    NSLog(@"veriosn = %@", version);
}

+ (void)sdkApplicationDidBecomeActive:(UIApplication *)application{
    // app启动
    
    [[AppsFlyerLib shared] start];
    [[FBSDKAppEvents shared] activateApp];
    
    [XMManager deepLinkApplicationDidBecomeActive:application];
}

+ (BOOL)sdkApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options{
    
    [XMManager deepLinkApplication:application openURL:url options:options];
    return YES;
}

+ (BOOL)sdkApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{
    
    [XMManager deepLinkApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

+ (BOOL)sdkApplication:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    [XMManager deepLinkApplication:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

+ (void)sdkApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    // With swizzling disabled you must set the APNs device token here.
    [[FIRMessaging messaging] setAPNSToken:deviceToken];
}

+ (void)sdkApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [[AppsFlyerLib shared] handlePushNotification:userInfo];
}

#pragma mark -- FIRMessagingDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)) {
    
  NSDictionary *userInfo = notification.request.content.userInfo;

  // With swizzling disabled you must let Messaging know about the message, for Analytics
   [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // [START_EXCLUDE]
  // Print message ID.
  if (userInfo[kGCMMessageIDKey]) {
    NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
  }
  // [END_EXCLUDE]

  // Print full message.
  NSLog(@"%@", userInfo);

  // Change this to your preferred presentation option
  completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0)) __API_UNAVAILABLE(tvos) {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
  if (userInfo[kGCMMessageIDKey]) {
    NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
  }

  // With swizzling disabled you must let Messaging know about the message, for Analytics
   [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Print full message.
  NSLog(@"%@", userInfo);

  completionHandler();
}

- (void)messaging:(FIRMessaging *)messaging
    didReceiveRegistrationToken:(NSString *)fcmToken{
    
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    XMConfig *config = [XMConfig sharedXMConfig];
    config.FCMToken = fcmToken;
    
    [YXNet uploadFCMToken:fcmToken result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        YXLog(@"FCMToken : isSuccess = %d",isSuccess);
    }];
}

#pragma mark -- AppsFlyerLibDelegate
// AppsFlyerLib implementation
//Handle Conversion Data (Deferred Deep Link)
-(void)onConversionDataSuccess:(NSDictionary*) installData {
    
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a non-organic install. Media source: %@  Campaign: %@",sourceID,campaign);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}
-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@",error);
}
//Handle Direct Deep Link
- (void) onAppOpenAttribution:(NSDictionary*) attributionData {
    NSLog(@"%@",attributionData);
}
- (void) onAppOpenAttributionFailure:(NSError *)error {
    NSLog(@"%@",error);
}

/// 崩溃预防
+ (void)avoidCrash{
    
    // 防崩溃
    [AvoidCrash makeAllEffective];
    
    // 崩溃上报
    [[NSNotificationCenter defaultCenter] addObserver:[XMManager sharedXMManager] selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
    // 上报失败回查
    NSDictionary *info = [NSUserDefaults objectForKey:YXBUGCache];
    [instance uploadOldBug:info];
}

- (void)dealwithCrashMessage:(NSNotification *)note {
    
    NSString *errorName   = note.userInfo[@"errorName"];
    NSString *errorPlace  = note.userInfo[@"errorPlace"];
    NSString *errorReason = note.userInfo[@"errorReason"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addValue:errorName   key:@"errorName"];
    [dict addValue:errorPlace  key:@"errorPlace"];
    [dict addValue:errorReason key:@"errorReason"];
    
    [instance uploadOldBug:dict];
}

- (void)uploadOldBug:(NSDictionary *)info{
    
    if (info.allKeys.count == 0) {
        return;;
    }
    
    // 存bug数据
    [NSUserDefaults addValue:info key:YXBUGCache];
    
    NSString *info_text = [info jk_JSONString];
    [YXNet uploadBugInfo:info_text result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            // 上报成功 移除
            [NSUserDefaults addValue:@{} key:YXBUGCache];
        }
    }];
}

/// 热修复
+ (void)hotfixWithAppleID:(NSString *)appleID{
    
    // 热修复
    [[XMManager sharedXMManager] hotfixMethodWithAppleID:appleID];
    
    // 热修复本地测试
//        [instance hotFixTest];
}

#pragma mark -- hotfix
- (void)hotfixMethodWithAppleID:(NSString *)appleID{

    [LYFix Fix];
    // 执行本地
    NSString *key = [NSString stringWithFormat:@"HotFix_%@",APPVERSION];
    
    NSArray *locaList = [NSUserDefaults objectForKey:key];
    if (locaList.count > 0) {

        [instance hotFixWithList:locaList];
    }

    [YXNet hotfixListWithAppleID:appleID result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            if (locaList.count == 0) {
                // 本地没有，执行线上
                [instance hotFixWithList:data];
            }

            // 替换本地
            [NSUserDefaults addValue:data key:key];
        }
    }];
}

- (void)hotFixWithList:(NSArray *)list{

    if (list.count == 0) {
        return;
    }

    for (NSDictionary *info in list) {

        NSString *fixCode = info[@"code"];
        if ([fixCode isKindOfClass:[NSString class]] && fixCode.length > 0) {

            [LYFix evalString:fixCode];
        }
    }
}

/// 修复测试
- (void)hotFixTest{

    [LYFix Fix];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"LYHotFix" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [LYFix evalString:js];
}

/// 三方统计玩家数据
/// @param type type
/// @param price price 支付时候传参
+ (void)sdkPlayerDataWithType:(NSInteger)type price:(NSString *)price{
    [YXStatis playerDataWithType:type price:price];
}

/// 三方统计玩家游戏VIP等级
/// @param vipLevel vip等级
+ (void)sdkAchievedVIPLevelEvent:(NSString *)vipLevel{
    [YXStatis achievedVIPLevelEvent:vipLevel];
}

/// 三方openURL:options:completionHandler:玩家游戏等级
/// @param level 等级
+ (void)sdkAchievedLevelEvent:(NSString *)level{
    [YXStatis achievedLevelEvent:level];
}

/// 三方统计玩家支付数据
/// @param amount 金额
+ (void)sdkPaymentEvent:(NSString *)amount{
    [YXStatis paymentEvent:amount];
}

/// 资源开始下载
+ (void)sdkStartDownloadResource{
    [YXStatis startDownloadResource];
}

/// 资源下载完成
+ (void)sdkFinishDownloadResource{
    [YXStatis finishDownloadResource];
}

/// 开始解压
+ (void)sdkStartUnzipResource{
    [YXStatis startUnzipResource];
}

/// 解压完成
+ (void)sdkFinishUnzipResource{
    [YXStatis finishUnzipResource];
}

/// 浏览器打开页面
/// @param url 网页
+ (void)sdkOpenUrl:(NSString *)url{
   
    if (url.length == 0) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
        
    }];
}

//+ (void)sdkOpenAgreement{
//    // http://www.justinfinitelane.com/privacy.htm
//    // http://www.justinfinitelane.com/user.html
//    [XMManager sdkOpenUrl:@"http://www.justinfinitelane.com/user.html"];
//}

/// 打开客服页面
+ (void)sdkOpenServiceView{
    
    XMServiceApiVC *vc = [[XMServiceApiVC alloc] init];
    vc.isDismiss = true;
    [vc present];
    
//    XMServiceVC *vc = [[XMServiceVC alloc] init];
//    [SELFVC presentViewController:vc animated:true completion:nil];
    
//    XMServiceApiVC *vc = [[XMServiceApiVC alloc] init];
//    vc.isClose = true;
//    
//    XMNavVC *nvc = [[XMNavVC alloc] initWithRootViewController:vc];
//    nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    nvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    nvc.mode = YXNavModeService;
//
//    [SELFVC presentViewController:nvc animated:true completion:nil];
}

/// 打开绑定
+ (void)sdkOpenBindView{
    
    [YXStatis uploadAction:statis_bind_touch];

    XMBindAccountVC *vc = [[XMBindAccountVC alloc] init];
    [SELFVC presentViewController:vc animated:true completion:nil];
}

+ (void)sdkTrans:(NSString *)text lan:(NSString *)lan result:(void(^)(BOOL isSucccess, NSString *text))result{
    
    [YXNet trans:text lan:lan result:result];
}

/// 设置SDK语言
/// @param language 语言
+ (void)sdkSetLanguage:(NSString *)language{
    
    [NSBundle sdkSetLanguage:language];
}

/// 获取存储语言语言
+ (NSString *)sdkGetCacheLanguage{
    
    return [NSBundle sdkGetCacheLanguage];
}

/// 获取当前系统语言
+ (NSString *)sdkGetSystemLanguage{
    return [NSBundle sdkGetSystemLanguage];
}

+ (void)advTest{

}

+ (void)sdkCheckNet:(void (^)(NetStatus status))block{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block) {
            NetStatus net_state;
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    net_state = NetStatusUnknown;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    net_state = NetStatusNotReachable;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    net_state = NetStatusReachableViaWWAN;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    net_state = NetStatusReachableViaWiFi;
                    break;
                default:
                    break;
            }
            block(net_state);
        }
    }];
    [manager startMonitoring];
}

/// 事件上报
/// @param event_name 事件名
/// @param jsonStr 一个Json字符串对应jsonStr字段
+ (void)uploadEvent:(NSString *)event_name jsonStr:(NSString *)jsonStr{
    [YXNet uploadEvent:event_name play_session:@"" properties:jsonStr];
    
    NSDictionary *dict = [jsonStr jk_dictionaryValue];
    [YXStatis uploadAction:event_name params:dict];
}

/// 应用内评论
+ (void)sdkRequestReview{
    [SKStoreReviewController requestReview];
}

/// AppStore 评论
+ (void)sdkAppStoreReview{
    // 跳转评论
    NSString *apple_id = [XMInfos sharedXMInfos].AppleID;
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", apple_id];
    [XMManager sdkOpenUrl:url];
}

/// App 详情页
+ (void)sdkAppStoreDetail{
    // 跳转详情
    NSString *apple_id = [XMInfos sharedXMInfos].AppleID;
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", apple_id];
    [XMManager sdkOpenUrl:url];
}

/// 弹框
/// - Parameter msg: 消息
+ (void)showMsg:(NSString *)msg{
    [YXHUD showInfoWithText:msg];
}



@end
