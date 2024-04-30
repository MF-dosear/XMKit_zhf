//
//  XMManager+Ad.h
//  Foxs
//
//  Created by Paul on 2023/6/25.
//  Copyright © 2023 YXQ. All rights reserved.
//

#import <XMKit_zhf/XMSDK.h>
#import <objc/runtime.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

static void * CacheRewardedAdKey = (void *)@"CacheRewardedAdKey";

@interface XMManager (Ad)<MARewardedAdDelegate>

@property (nonatomic, strong) MARewardedAd *rewardedAd;

/// 加载激励广告
- (void)loadRewardedAd;

@end

NS_ASSUME_NONNULL_END
