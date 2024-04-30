//
//  XMAppDelegate.m
//  XMKit_zhf
//
//  Created by 564057354@qq.com on 04/18/2024.
//  Copyright (c) 2024 564057354@qq.com. All rights reserved.
//

#import "XMAppDelegate.h"
#import "Config.h"
#import "XMViewController.h"

@implementation XMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *vc = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = vc;
    
    // SDK初始化
    XMInfos *info = [XMInfos sharedXMInfos];
    
    info.AppID  = AppID;
    info.AppKey = AppKey;
    
    info.appsFlyerKey = AppsFlyerKey;
    info.AppleID = AppleID;
    
    info.AppLovinSdkKey = AppLovinSdkKey;
    info.rewardedAdID = AdvID; // 广告appkey 没有广告则不传
    
    [XMManager sdkApplication:application didFinishLaunchingWithOptions:launchOptions deeplinkBlock:^(BOOL flag, NSString * _Nullable deepLinkValue, NSDictionary * _Nullable params) {
        
        /// 示例方法 cp请注释
//        [self test:flag deepLinkValue:deepLinkValue];
    }];
    
    return YES;
}

- (void)test:(BOOL)isSuccess deepLinkValue:(NSString *)deepLinkValue{
    NSString *msg = [NSString stringWithFormat:@"isSuccess = %d, deepLinkValue = %@", isSuccess, deepLinkValue];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"深度链接" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self.window.rootViewController presentViewController:alert animated:true completion:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
  
    [XMManager sdkApplicationDidBecomeActive:application];
}

#pragma mark --分享
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    return [XMManager sdkApplication:app openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [XMManager sdkApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    return [XMManager sdkApplication:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [XMManager sdkApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [XMManager sdkApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}


@end
