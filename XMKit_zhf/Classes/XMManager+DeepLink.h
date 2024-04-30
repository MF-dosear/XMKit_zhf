//
//  XMManager+DeepLink.h
//  XMSDK
//
//  Created by Paul on 2023/12/29.
//  Copyright © 2023 YXQ. All rights reserved.
//

#import <XMKit_zhf/XMSDK.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMManager (DeepLink)<AppsFlyerDeepLinkDelegate,AppsFlyerLibDelegate>

+ (void)deepLinkApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)deepLinkApplication:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;

+ (void)deepLinkApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options;


+ (void)deepLinkApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation;

@end

NS_ASSUME_NONNULL_END
