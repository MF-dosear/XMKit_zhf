///
///  YXInit.h
///  XMSDK
///
///  Created by G.E.M on 2023/8/13.
///  Copyright © 2023 G.E.M. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <XMKit_zhf/Singleton.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMInfos : NSObject
singleton_interface(XMInfos)

/// 初始化信息
/// Apple ID
@property (nonatomic, copy) NSString *AppleID;
/// super appid
@property (nonatomic, copy) NSString *AppID;
/// super appkey
@property (nonatomic, copy) NSString *AppKey;
/// link后缀 包名
@property (nonatomic, copy) NSString *link_suffix;
/// appsFlyer开发Key
@property (nonatomic, copy) NSString *appsFlyerKey;
/// appsFlyer的ID，需用纯数字在此设置应用 ID，不含“id”前缀
//@property (nonatomic, copy) NSString *appsFlyerID;
/// AppLovin SDK Key
@property (nonatomic, copy) NSString *AppLovinSdkKey;
/// 广告ID
@property (nonatomic, copy) NSString *rewardedAdID;
///// 广告测试设备
//@property (nonatomic, copy) NSArray *testDeviceIdentifiers;
///// IronSource appkey
//@property (nonatomic, copy) NSString *ironSource_appkey;

/// 角色信息
/// 服务器名字
@property (nonatomic, copy) NSString *serverName;
/// 游戏区服
@property (nonatomic, copy) NSString *serverID;
/// 角色名
@property (nonatomic, copy) NSString *roleName;
/// 角色id
@property (nonatomic, copy) NSString *roleID;
/// 角色等级
@property (nonatomic, copy) NSString *roleLevel;
/// Vip等级
@property (nonatomic, copy) NSString *psyLevel;

/// 订单信息
/// cp方产生的订单(必传)
@property (nonatomic, copy) NSString *cpOrder;
/// 支付需要的价格单位(元)(必传)
@property (nonatomic, copy) NSString *price;
/// 商品号(必传)
@property (nonatomic, copy) NSString *goodsID;
/// 商品名称
@property (nonatomic, copy) NSString *goodsName;
/// 拓展字段
@property (nonatomic, copy) NSString *extends;
/// 回调地址
@property (nonatomic, copy) NSString *notify;

@end

NS_ASSUME_NONNULL_END
