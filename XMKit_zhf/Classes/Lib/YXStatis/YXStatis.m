//
//  YXStatis.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/13.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "YXStatis.h"

#import <AppsFlyerLib/AppsFlyerLib.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import <FirebaseCore/FirebaseCore.h>

// 用户完成注册或者使用任何第三方渠道进行首次登录
static NSString * const kSODRegister = @"Registration";
// 登录
static NSString * const kSODLogin = @"login";
// 次留，即当日的注册用户，次日有再次登录
static NSString * const kSODNextDayLogin = @"next_1_day_login";
// 定义参考次留，3留
static NSString * const kSOD3DaysLogin = @"next_3_days_login";
// 定义参考次留，7留
static NSString * const kSOD7DaysLogin = @"next_7_days_login";
// 定义参考次留，14留
static NSString *const kSOD14DaysLogin = @"next_14_Days_Login";
// 定义参考次留，月留
static NSString *const kSOD30DaysLogin = @"MLY_Login";
// 下载资源
static NSString * const kSODStartDownLoad = @"StartDownLoad";
// 下载结束
static NSString * const kSODEndDownLoad = @"EndDownLoad";
// 解压开始
static NSString * const kSODStartUnzip = @"StartZip";
// 解压结束
static NSString * const kSODEndUnzip = @"EndZip";
// 首充
static NSString * const kSODNewRolePack = @"NewRole_Pack";
// 完成新手指导
static NSString * const kSODNewRoleTutorial = @"NewRole_Tutorial";
// 首次购买月卡
static NSString * const kSODNewRoleMonth = @"NewRole_Month";
// 首次购买至尊卡
static NSString * const kSODNewRoleSupermacy = @"NewRole_SupreMacy";
// 新角色创建
static NSString * const kSODNewRoleCreate = @"NewRole_Create";
// 加载资源，初始资源loading完毕
static NSString * const kSODInitialResourceLoadingComplete = @"Loading_completed";
// 进入游戏，玩家成功进入游戏
static NSString * const kSODEnterGame = @"Lead";
// 点击计费点，点击游戏内任意计费点
static NSString * const kSODClickBillingPoint = @"Initiate_Checkout";
// 游戏内-军团，申请加入或创建军团
static NSString * const kSODApplyJoinOrCreateArmy = @"Add_To_Wishlist";
// 开始新手流程
static NSString * const kSODStartNoviceGuide = @"Start_Tutorial";
// 完成新手引导
static NSString * const kSODCompleteNoviceGuide = @"Tutorial_Completed";
// 创角首日累充达到29.99
static NSString * const kSODFirstDayRecharge29_99 = @"Payment_into";
// 创建账号当日领取4.99月卡（首日月卡4.99）
static NSString * const kSODBMonthCard = @"Buy_MonthCard";

#import <XMKit_zhf/XMInfos.h>

@implementation YXStatis

#pragma mark - 三方统计玩家数据
+ (void)uploadAction:(NSString *)action{
    
    [[FBSDKAppEvents shared] logEvent:action];
    [[AppsFlyerLib shared] logEvent:action withValues:@{}];
    [FIRAnalytics logEventWithName:action parameters:@{}];
}

+ (void)uploadAction:(NSString *)action params:(NSDictionary *)params{
    
    [[FBSDKAppEvents shared] logEvent:action parameters:params];
    [[AppsFlyerLib shared] logEvent:action withValues:params];
    [FIRAnalytics logEventWithName:action parameters:params];
}

/// 三方统计玩家数据
/// @param type type
/// @param price price
+ (void)playerDataWithType:(YXStatisType)type price:(NSString *)price{
    switch (type) {
        case YXStatisTypeNewroleMonth: [YXStatis uploadAction:kSODNewRoleMonth];
            break;
        case YXStatisTypeNewrolePack:  [YXStatis uploadAction:kSODNewRolePack];
            break;
        case YXStatisTypeNewroleSupremacy: [YXStatis uploadAction:kSODNewRoleSupermacy];
            break;
        case YXStatisTypeNewroleTutorial:[YXStatis uploadAction:kSODNewRoleTutorial];
            break;
        case YXStatisTypeNewroleCreate:[YXStatis uploadAction:kSODNewRoleCreate];
            break;
        case YXStatisTypeInitialResourceLoadingComplete:[YXStatis uploadAction:kSODInitialResourceLoadingComplete];
            break;
        case YXStatisTypeEnterGame:[YXStatis uploadAction:kSODEnterGame];
            break;
        case YXStatisTypeClickBillingPoint:[YXStatis uploadAction:kSODClickBillingPoint];
            break;
        case YXStatisTypeJoinOrCreateArmy:[YXStatis uploadAction:kSODApplyJoinOrCreateArmy];
            break;
        case YXStatisTypeAFEventPurchase:{
            [[AppsFlyerLib shared] logEvent:AFEventPurchase withValues: @{AFEventParamRevenue:price}];
            [FIRAnalytics logEventWithName:kFIREventPurchase parameters:@{
                kFIRParameterValue:@([price floatValue]),
                kFIRParameterCurrency:@"USD"
            }];
            [[FBSDKAppEvents shared] logEvent:AFEventPurchase];
        }
            break;
        case YXStatisTypeStartNoviceGuide:[YXStatis uploadAction:kSODStartNoviceGuide];
            break;
        case YXStatisTypeCompleteNoviceGuide:[YXStatis uploadAction:kSODCompleteNoviceGuide];
            break;
        case YXStatisTypeFirstDayRecharge29_99:[YXStatis uploadAction:kSODFirstDayRecharge29_99];
            break;
        case YXStatisTypeBMonthCard:[YXStatis uploadAction:kSODBMonthCard];
            break;
        default:
            break;
    }
}

/// 三方统计玩家游戏VIP等级
/// @param vipLevel 等级
+ (void)achievedVIPLevelEvent:(NSString *)vipLevel{
    if (!vipLevel || (!vipLevel.length)) {
        return;
    }
    
    [YXStatis uploadAction:vipLevel];
}

/// 三方统计玩家游戏等级
/// @param level 等级
+ (void)achievedLevelEvent:(NSString *)level{
    if (!level || (!level.length)) {
        return;
    }
    
    NSDictionary *params = @{FBSDKAppEventParameterNameLevel:level};
    [[FBSDKAppEvents shared] logEvent:FBSDKAppEventNameAchievedLevel parameters:params];
    
    NSString *levelString = [NSString stringWithFormat:@"level%@",level];
    [[AppsFlyerLib shared] logEvent:levelString withValues:@{}];
    
    [FIRAnalytics logEventWithName:levelString parameters:@{}];
}

/// 三方统计玩家支付数据
/// @param amount 金额
+ (void)paymentEvent:(NSString *)amount{
    amount = [amount stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *eventName = [NSString stringWithFormat:@"Pay%@",amount];
    
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [values addValue:amount key:AFEventParamRevenue];
    
    [[FBSDKAppEvents shared] logEvent:eventName];
    [[AppsFlyerLib shared] logEvent:eventName withValues:@{}];
    [FIRAnalytics logEventWithName:eventName parameters:@{}];
}

/// 资源开始下载
+ (void)startDownloadResource{
    [YXStatis uploadAction:kSODStartDownLoad];
}

/// 资源下载完成
+ (void)finishDownloadResource{
    [YXStatis uploadAction:kSODEndDownLoad];
}

/// 开始解压
+ (void)startUnzipResource{
    [YXStatis uploadAction:kSODStartUnzip];
}

/// 解压完成
+ (void)finishUnzipResource{
    [YXStatis uploadAction:kSODEndUnzip];
}

/// 注册
/// @param method method
+ (void)userRegistration:(NSString *)method{
    [YXStatis uploadAction:kSODRegister];
    [self completedRegistrationEvent:method];
}

+ (void)completedRegistrationEvent:(NSString *)method{
    if (!method || (!method.length)) {
        return;
    }
    
    NSDictionary *params = @{FBSDKAppEventParameterNameRegistrationMethod : method};
    [[FBSDKAppEvents shared] logEvent:FBSDKAppEventNameCompletedRegistration parameters:params];
}

/// 登录
/// @param type 状态
+ (void)userLogin:(YXStatisMode)type{
    switch (type) {
        case YXStatisModeLogin:  [YXStatis uploadAction:kSODLogin];
            break;
        case YXStatisModeSecond: [YXStatis uploadAction:kSODNextDayLogin];
            break;
        case YXStatisModeThree:  [YXStatis uploadAction:kSOD3DaysLogin];
            break;
        case YXStatisModeSeven:  [YXStatis uploadAction:kSOD7DaysLogin];
            break;
        case YXStatisModeFourteen:  [YXStatis uploadAction:kSOD14DaysLogin];
            break;
        case YXStatisModeMonth:  [YXStatis uploadAction:kSOD30DaysLogin];
            break;
        default:
            break;
    }
}

@end
