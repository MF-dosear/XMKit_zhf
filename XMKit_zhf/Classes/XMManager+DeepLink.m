//
//  XMManager+DeepLink.m
//  XMSDK
//
//  Created by Paul on 2023/12/29.
//  Copyright © 2023 YXQ. All rights reserved.
//

#import "XMManager+DeepLink.h"
#import "XMManager+BK.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation XMManager (DeepLink)

+ (void)deepLinkApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // AppsFlyer
    [AppsFlyerLib shared].deepLinkDelegate = [XMManager sharedXMManager];
    [AppsFlyerLib shared].delegate = [XMManager sharedXMManager];

    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                // fb权限
                [XMManager sdkSetFBAdTrack:true];
                // fb延时深度链接
                [XMManager facebookDeepLink];
            }else{
                // fb权限
                [XMManager sdkSetFBAdTrack:false];
            }
        }];
    } else {
        // fb权限
        [XMManager sdkSetFBAdTrack:[ASIdentifierManager.sharedManager isAdvertisingTrackingEnabled]];
        // fb延时深度链接
        [XMManager facebookDeepLink];
    }
}

/// Facebook延时
+ (void)facebookDeepLink{
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        
        if (url) {
            [XMManager facebookDeepLinkWithUrl:url];
        }
    }];
}

+ (void)sdkSetFBAdTrack:(BOOL)enabled{
    [FBAdSettings setAdvertiserTrackingEnabled:enabled];
    [FBSDKSettings sharedSettings].isAdvertiserTrackingEnabled = enabled;
}

+ (void)deepLinkApplication:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    // AppsFlyer
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
    // Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application continueUserActivity:userActivity];
    // facebook 深度链接
    [XMManager facebookDeepLinkWithUrl:userActivity.webpageURL];
}

+ (void)deepLinkApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options{
    
    // AppsFlyer
    [[AppsFlyerLib shared] handleOpenUrl:url options:options];
    // Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
    // facebook 深度链接
    [XMManager facebookDeepLinkWithUrl:url];
}

+ (void)deepLinkApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{
    
    // AppsFlyer
    [[AppsFlyerLib shared] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    // Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    // facebook 深度链接
    [XMManager facebookDeepLinkWithUrl:url];
}

#pragma mark -- AppsFlyerDeepLinkDelegate
- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *)result{
    
    switch (result.status) {
        case AFSDKDeepLinkResultStatusNotFound: NSLog(@"[AFSDK] Deep link not found");
            break;
        case AFSDKDeepLinkResultStatusFailure:  NSLog(@"Error %@", result.error);
            break;
        case AFSDKDeepLinkResultStatusFound: NSLog(@"[AFSDK] Deep link found");
            break;
        default:
            break;
    }
    
    AppsFlyerDeepLink *deepLinkObj = result.deepLink;
    if ([deepLinkObj.clickEvent.allKeys containsObject:@"deep_link_sub2"]) {
        NSString *ReferrerId = deepLinkObj.clickEvent[@"deep_link_sub2"];
        NSLog(@"[AFSDK] AppsFlyer: Referrer ID: %@", ReferrerId);
    } else {;
        NSLog(@"[AFSDK] Could not extract referrerId");
    }
    
    NSString *deepLinkStr = deepLinkObj.toString;
    NSLog(@"[AFSDK] DeepLink data is: %@", deepLinkStr);
    
    if (deepLinkObj.isDeferred) {
        NSLog(@"[AFSDK] This is a deferred deep link");
    } else {
        NSLog(@"[AFSDK] This is a direct deep link");
    }
    
    NSString *deep_link_value = deepLinkObj.deeplinkValue;
    NSDictionary *clickEvent = deepLinkObj.clickEvent;
    [XMManager handelAppsFlyerWithDeepLinkValue:deep_link_value clickEvent:clickEvent];
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
    
    BOOL is_first_launch = [installData[@"is_first_launch"] boolValue];
    if (is_first_launch) {
        NSString *deep_link_value = installData[@"deep_link_value"];
        [XMManager handelAppsFlyerWithDeepLinkValue:deep_link_value clickEvent:installData];
    } else {
        NSLog(@"Install from a non-owned media");
    }
}

-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"onConversionDataFail：%@",error);
}

//Handle Direct Deep Link
- (void)onAppOpenAttribution:(NSDictionary*) attributionData {
    NSLog(@"onAppOpenAttribution：%@",attributionData);
    
    NSString *deep_link_value = attributionData[@"deep_link_value"];
    [XMManager handelAppsFlyerWithDeepLinkValue:deep_link_value clickEvent:attributionData];
}

- (void)onAppOpenAttributionFailure:(NSError *)error {
    NSLog(@"onAppOpenAttributionFailure：%@",error);
}

+ (void)handelAppsFlyerWithDeepLinkValue:(NSString *)deep_link_value clickEvent:(NSDictionary *)clickEvent{
    
    if (deep_link_value.length > 0){
        [XMManager sharedXMManager].deeplinkBlock(true, deep_link_value, clickEvent);
        [XMManager sharedXMManager].isDeeplinkBack = true;
    }
}

#pragma mark -- Facebook 深度链接
+ (void)facebookDeepLinkWithUrl:(NSURL *)url{
    NSDictionary *params = [url jk_queryDictionary];
    NSString *deep_link_value = params[@"ilife_deep_link_key"];
    
    if (deep_link_value.length > 0){
        [XMManager sharedXMManager].deeplinkBlock(true, deep_link_value, params);
        [XMManager sharedXMManager].isDeeplinkBack = true;
    }
}

@end



////
////  XMManager+DeepLink.m
////  XMSDK
////
////  Created by Paul on 2023/12/29.
////  Copyright © 2023 YXQ. All rights reserved.
////
//
//#import "XMManager+DeepLink.h"
//#import "XMManager+BK.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBAudienceNetwork/FBAudienceNetwork.h>
//#import <objc/runtime.h>
//#import <AppTrackingTransparency/AppTrackingTransparency.h>
//
//@implementation XMManager (DeepLink)
//
//+ (void)deepLinkApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    // AppsFlyer
//    [AppsFlyerLib shared].deepLinkDelegate = [XMManager sharedXMManager];
//    [AppsFlyerLib shared].delegate = [XMManager sharedXMManager];
//}
//
//+ (void)deepLinkApplication:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
//    
//    // AppsFlyer
//    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
//    // Facebook
//    [[FBSDKApplicationDelegate sharedInstance] application:application continueUserActivity:userActivity];
//    // facebook 深度链接
//    [XMManager facebookDeepLinkWithUrl:userActivity.webpageURL];
//}
//
//+ (void)deepLinkApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options{
//    
//    // AppsFlyer
//    [[AppsFlyerLib shared] handleOpenUrl:url options:options];
//    // Facebook
//    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
//    // facebook 深度链接
//    [XMManager facebookDeepLinkWithUrl:url];
//}
//
//+ (void)deepLinkApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{
//    
//    // AppsFlyer
//    [[AppsFlyerLib shared] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
//    // Facebook
//    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    // facebook 深度链接
//    [XMManager facebookDeepLinkWithUrl:url];
//}
//
//#pragma mark -- AppsFlyerDeepLinkDelegate
//- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *)result{
//    AppsFlyerDeepLink *deepLink = result.deepLink;
//    [XMManager appsFlyerDeepLinkWithDeepLinkValue:deepLink.deeplinkValue deepLinkParams:deepLink.clickEvent];
//}
//
//#pragma mark -- AppsFlyerLibDelegate
///// 延时深度链接
//-(void)onConversionDataSuccess:(NSDictionary *)installData {
//    [XMManager appsFlyerDeepLinkWithDeepLinkValue:installData[@"deep_link_value"] deepLinkParams:installData];
//    
//    // 统计
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict addValue:installData[@"deep_link_value"] key:@"deep_link_value"];
//    [dict addValue:installData                     key:@"deepLinkParams"];
//    
//    NSString *jsonStr = [dict jk_JSONString];
//    [XMManager uploadEvent:@"AppsFlyer_deeplink_delayed" jsonStr:jsonStr];
//}
//
//-(void)onConversionDataFail:(NSError *)error {
//    NSLog(@"onConversionDataFail：%@",error);
//}
//
//- (void)onAppOpenAttribution:(NSDictionary*)attributionData {
//    [XMManager appsFlyerDeepLinkWithDeepLinkValue:attributionData[@"deep_link_value"] deepLinkParams:attributionData];
//}
//
//- (void)onAppOpenAttributionFailure:(NSError *)error {
//    
//}
//
//#pragma mark -- AppsFlyer 深度链接
//+ (void)appsFlyerDeepLinkWithDeepLinkValue:(NSString *)deep_link_value deepLinkParams:(NSDictionary *)deepLinkParams{
//    XMManager *manager = [XMManager sharedXMManager];
//    
//    if (deep_link_value.length > 0){
//        manager.deepLinkValue = deep_link_value;
//        manager.deepLinkParams = deepLinkParams;
//    }
//    
//    // 深度链接回调
//    if (deep_link_value > 0 && [XMManager sharedXMManager].deeplinkBlock){
//        // AppsFlyer深度链接
//        [XMManager sharedXMManager].deeplinkBlock(true, manager.deepLinkValue, manager.deepLinkParams);
//    }
//}
//
//#pragma mark -- Facebook 深度链接
//+ (void)facebookDeepLinkWithUrl:(NSURL *)url{
//    
//    NSDictionary *deepLinkParams = [url jk_queryDictionary];
//    NSString *deep_link_value = deepLinkParams[@"ilife_deep_link_key"];
//    
//    XMManager *manager = [XMManager sharedXMManager];
//    if (deep_link_value.length > 0){
//        manager.deepLinkValue = deep_link_value;
//        manager.deepLinkParams = deepLinkParams;
//    }
//}
//
//#pragma mark -- 调用深度链接方法
//+ (void)sdkDeepLinkWithBlock:(XMDeepLinkBlock)deeplinkBlock{
//    
//    XMManager *manager = [XMManager sharedXMManager];
//    manager.deeplinkBlock = deeplinkBlock;
//    
//    if (manager.deepLinkValue.length > 0){
//        // fb深度链接
//        [XMManager sharedXMManager].deeplinkBlock(true, manager.deepLinkValue, manager.deepLinkParams);
//    } else {
//        
//        if (@available(iOS 14, *)) {
//
//            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//
//                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
//                    // fb权限
//                    [XMManager sdkSetFBAdTrack:true];
//                    // fb延时深度链接
//                    [XMManager facebookDeepLink];
//                }else{
//                    // fb权限
//                    [XMManager sdkSetFBAdTrack:false];
//                    // fbs延时深度链接
//                    [XMManager sharedXMManager].deeplinkBlock(false, nil, nil);
//                }
//            }];
//        } else {
//            // fb权限
//            [XMManager sdkSetFBAdTrack:true];
//            // fb延时深度链接
//            [XMManager facebookDeepLink];
//        }
//    }
//}
//
//+ (void)sdkSetFBAdTrack:(BOOL)enabled{
//    [FBAdSettings setAdvertiserTrackingEnabled:enabled];
//    [FBSDKSettings sharedSettings].isAdvertiserTrackingEnabled = enabled;
//}
//
///// Facebook延时
//+ (void)facebookDeepLink{
//    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
//        
//        // 存url
//        [XMManager facebookDeepLinkWithUrl:url];
//        
//        // 深度链接回调
//        XMManager *manager = [XMManager sharedXMManager];
//        BOOL isSuccess = manager.deepLinkValue.length > 0;
//        // fb深度链接
//        [XMManager sharedXMManager].deeplinkBlock(isSuccess, manager.deepLinkValue, manager.deepLinkParams);
//        
//        // 统计
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict addValue:url.absoluteString key:@"url"];
//        [dict addValue:error.description  key:@"error"];
//        
//        NSString *jsonStr = [dict jk_JSONString];
//        [XMManager uploadEvent:@"facebook_deeplink_delayed" jsonStr:jsonStr];
//    }];
//}
//
//@end
