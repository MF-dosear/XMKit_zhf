//
//  YXDefine.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#ifndef YXDefine_h
#define YXDefine_h

#import <AdSupport/AdSupport.h>

/// 字体
#define FONT_SYSTEM(value)      [UIFont systemFontOfSize:value]
#define FONT_BOLD(value)        [UIFont boldSystemFontOfSize:value]

#define FONT_30                  FONT_SYSTEM(30)
#define FONT_20                  FONT_SYSTEM(20)
#define FONT_18                  FONT_SYSTEM(18)
#define FONT_16                  FONT_SYSTEM(16)
#define FONT_14                  FONT_SYSTEM(14)
#define FONT_12                  FONT_SYSTEM(12)
#define FONT_10                  FONT_SYSTEM(10)

/// 自定义字体
#define FONTNAME(value)          [UIFont boldSystemFontOfSize:value]

/// 获取通知中心
#define MCNOTI [NSNotificationCenter defaultCenter]

/// GCD异步线程
#define ASYNC_GLOBAL_GCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
/// 主线程
#define ASYNC_MAIN_GCD(block)   dispatch_async(dispatch_get_main_queue(),block)

/// 关闭自动调节尺寸
#define ADJUSTINSETS_NO(scrollView) if(IS_iOS11){scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}else{self.automaticallyAdjustsScrollViewInsets = false;}

/// 设备信息
#define DEV                      [UIDevice currentDevice]
/// 手机系统版本
#define DEV_SYSTEM_VERSION       [DEV systemVersion]
/// 手机序列号
#define IDENTIFIERNUMBER         [DEV uniqueIdentifier]
/// 手机别名： 用户定义的名称
#define DEV_ALIAS                [DEV name]
/// 设备名称
#define DEV_NAME                 [DEV systemName]
/// 手机型号
#define DEV_MODEL                [DEV model]
/// 地方型号  （国际化区域名称）
#define DEV_LOCALIZE_MODEL       [DEV localizedModel]
/// 设备UUID
#define DEV_UUID                 [XMCommon getUUIDInKeychain]
/// 设备型号名称
#define DEV_MODELNAME            [UIDevice modelName]
/// 设备类型
#define DEV_BRAND                [UIDevice brand]
/// 设备IDFV
#define DEV_IDFV                 [DEV identifierForVendor].UUIDString
/// 设备Sn
#define Device_Sn                [DEV identifierForVendor].UUIDString
/// 设备IDFA
#define DEV_IDFA                 [XMCommon idfa]


#define IS_iOS8                  @available(iOS 8.0, *)
#define IS_iOS9                  @available(iOS 9.0, *)
#define IS_iOS10                 @available(iOS 10.0, *)
#define IS_iOS11                 @available(iOS 11.0, *)
#define IS_iOS12                 @available(iOS 12.0, *)
#define IS_iOS13                 @available(iOS 13.0, *)
#define IS_iOS14                 @available(iOS 14.0, *)

/// 弱引用
#define WEAKSELF                 __weak typeof(self) weakSelf = self
/// 强引用
#define STRONGSELF               __strong typeof(self) strongSelf = self

/// APP 信息
#define APPINFO                  [[NSBundle mainBundle] infoDictionary]

/// 名称
#define APPNAME                  APPINFO[@"CFBundleName"]
/// 版本
#define APPVERSION               APPINFO[@"CFBundleShortVersionString"]
/// build版本
#define APPBundleVersion         APPINFO[@"CFBundleVersion"]
/// BundleID版本
#define APPBundleID              APPINFO[@"CFBundleIdentifier"]

/// 图片
#define IMAGE(name)              [UIImage imageBundleNamed:name]

/// 本地化
#define LocalizedString(name)    [NSBundle localizedString:name]

typedef NS_ENUM(NSUInteger, FxHEARTMode) {
    FxHEARTModeLogin, // 登录
    FxHEARTModeLogout, // 登出
};


#endif /* YXDefine_h */
