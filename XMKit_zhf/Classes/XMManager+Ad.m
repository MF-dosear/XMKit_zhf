//
//  XMManager+Ad.m
//  Foxs
//
//  Created by Paul on 2023/6/25.
//  Copyright © 2023 YXQ. All rights reserved.
//

#import "XMManager+Ad.h"
#import "XMManager+BK.h"

@implementation XMManager (Ad)

- (MARewardedAd *)rewardedAd{

    id typeValue = objc_getAssociatedObject(self, CacheRewardedAdKey);
    return (MARewardedAd *)typeValue;
}


- (void)setRewardedAd:(MARewardedAd *)rewardedAd{

    objc_setAssociatedObject(self, CacheRewardedAdKey, rewardedAd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)loadRewardedAd{

    XMInfos *infos = [XMInfos sharedXMInfos];
    
    if (self.rewardedAd == nil){
        // 实例化广告
        self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:infos.rewardedAdID];
        self.rewardedAd.delegate = self;
    }

    // 加载广告
    [self.rewardedAd loadAd];
}

+ (void)sdkShowRewardedAd:(NSString *)adUnitId{
    XMInfos *infos = [XMInfos sharedXMInfos];
    if ([infos.rewardedAdID isEqualToString:adUnitId]){
        
        [XMManager sdkShowRewardedAd];
    } else {
        infos.rewardedAdID = adUnitId;
        
        XMManager *manager = [XMManager sharedXMManager];
        // 实例化广告
        manager.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:infos.rewardedAdID];
        manager.rewardedAd.delegate = manager;
        // 加载广告
        [manager.rewardedAd loadAd];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [XMManager sdkShowRewardedAd];
        });
    }
}

+ (void)sdkShowRewardedAd{
    
    // 点击rewarded广告
    XMManager *manager = [XMManager sharedXMManager];

    if ([manager.rewardedAd isReady]){
        /// 广告加载成功
        [manager.rewardedAd showAd];
    } else {
        /// 广告加载失败
        [manager.rewardedAd loadAd];
        [XMManager sdkShowReward:1];
    }
}

- (void)didLoadAd:(nonnull MAAd *)ad {
    
}

- (void)didClickAd:(nonnull MAAd *)ad {
    
}

- (void)didDisplayAd:(nonnull MAAd *)ad {
    // 当显示全屏广告时候
    [XMManager sdkShowReward:2];
}

- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {
    // 播放失败
    [XMManager sdkShowReward:3];
    [self.rewardedAd loadAd];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
    
    [self.rewardedAd loadAd];
}

- (void)didHideAd:(nonnull MAAd *)ad {
    // 关闭广告
    [XMManager sdkShowReward:5];
    [self.rewardedAd loadAd];
}

- (void)didCompleteRewardedVideoForAd:(nonnull MAAd *)ad {
    // 播放完成
    [XMManager sdkShowReward:4];
}

- (void)didRewardUserForAd:(nonnull MAAd *)ad withReward:(nonnull MAReward *)reward {
    // 发放奖励
    [XMManager sdkShowReward:6];
}

- (void)didStartRewardedVideoForAd:(nonnull MAAd *)ad {
    
}

+ (void)sdkAdvTest{
    [[ALSdk shared] showMediationDebugger];
}


@end
