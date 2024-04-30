//
//  NSBundle+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XMGAMELanguageMode) {
    /// 跟随系统
    XMGAMELanguageModeSystem = 0,
    /// 英文
    XMGAMELanguageModeEN,
    /// 简体中文
    XMGAMELanguageModeCN,
    /// 繁体中文
    XMGAMELanguageModeTC,
    /// 日文
    XMGAMELanguageModeJP,
    /// 韩语
    XMGAMELanguageModeKo,
    /// 德语
    XMGAMELanguageModeDe,
    /// 俄语
    XMGAMELanguageModeRu,
    /// 法语
    XMGAMELanguageModeFr,
    /// 葡萄牙语
    XMGAMELanguageModePt,
    /// 西班牙语
    XMGAMELanguageModeEs,
    /// 意大利语
    XMGAMELanguageModeIt,
    /// 阿拉伯语
    XMGAMELanguageModeAr,
    /// 越南语
    XMGAMELanguageModeVi,
    /// 泰语
    XMGAMELanguageModeTh
};

@interface NSBundle (YX)

+ (instancetype)bundle;

/// 获取当前系统语言
+ (NSString *)sdkGetSystemLanguage;

/// 设置SDK语言
/// @param language 语言
+ (void)sdkSetLanguage:(NSString *)language;

/// 获取存储语言语言
+ (NSString *)sdkGetCacheLanguage;

/// 服务器语言
+ (NSString *)serverLanguage;

/// H5语言
+ (NSString *)h5Language;

/// 获取语言文本名称
/// - Parameter mode: 语言类型
+ (NSString *)lanFileWithMode:(XMGAMELanguageMode)mode;

/// 本地化语言
+ (NSString *)localizedString:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
