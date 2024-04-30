//
//  YXStatis.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/13.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header_statis.h"

typedef NS_ENUM(NSUInteger, YXStatisMode) {
    YXStatisModeLogin,
    YXStatisModeSecond,
    YXStatisModeThree,
    YXStatisModeSeven,
    YXStatisModeFourteen,
    YXStatisModeMonth
};

typedef NS_ENUM(NSUInteger, YXStatisType) {
    YXStatisTypeNewroleMonth = 1,// 首次购买月卡
    YXStatisTypeNewrolePack = 2,// 首充
    YXStatisTypeNewroleSupremacy = 3,// 首次购买至尊卡
    YXStatisTypeNewroleTutorial = 4,// 完成新手指导
    YXStatisTypeNewroleCreate = 5,// 完成新角色创建
    YXStatisTypeInitialResourceLoadingComplete = 6,// 加载资源，初始资源loading完毕
    YXStatisTypeEnterGame = 7,// 进入游戏，玩家成功进入游戏
    YXStatisTypeClickBillingPoint = 8,// 点击计费点，点击游戏内任意计费点
    YXStatisTypeJoinOrCreateArmy = 9,// 游戏内-军团，申请加入或创建军团
    YXStatisTypeAFEventPurchase = 10,// af的购买事件
    YXStatisTypeStartNoviceGuide = 11,// 开始新手流程
    YXStatisTypeCompleteNoviceGuide = 12,// 开始新手流程
    YXStatisTypeFirstDayRecharge29_99 = 13,// 创角首日累充达到29.99
    YXStatisTypeBMonthCard = 14,// 创建账号当日领取4.99月卡（首日月卡4.99）
};

NS_ASSUME_NONNULL_BEGIN

@interface YXStatis : NSObject

#pragma mark - 三方统计玩家数据
+ (void)uploadAction:(NSString *)action;

+ (void)uploadAction:(NSString *)action params:(NSDictionary *)params;

/// 三方统计玩家数据
/// @param type type
/// @param price price
+ (void)playerDataWithType:(YXStatisType)type price:(NSString *)price;

/// 三方统计玩家游戏VIP等级
/// @param vipLevel 等级
+ (void)achievedVIPLevelEvent:(NSString *)vipLevel;

/// 三方统计玩家游戏等级
/// @param level 等级
+ (void)achievedLevelEvent:(NSString *)level;

/// 三方统计玩家支付数据
/// @param amount 金额
+ (void)paymentEvent:(NSString *)amount;

/// 资源开始下载
+ (void)startDownloadResource;

/// 资源下载完成
+ (void)finishDownloadResource;

/// 开始解压
+ (void)startUnzipResource;

/// 解压完成
+ (void)finishUnzipResource;

/// 注册
/// @param method method
+ (void)userRegistration:(NSString *)method;

/// 登录
/// @param type 状态
+ (void)userLogin:(YXStatisMode)type;

@end

NS_ASSUME_NONNULL_END
