//
//  NSBundle+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "NSBundle+YX.h"
#import "XMManager.h"

@implementation NSBundle (YX)

+ (instancetype)bundle{
    
    NSBundle *bundle = [NSBundle bundleForClass:[XMManager class]];
    return bundle;
}

/// 设置SDK语言
/// @param language 语言
+ (void)sdkSetLanguage:(NSString *)language{
    
    XMGAMELanguageMode mode = XMGAMELanguageModeEN;
    if ([language isEqualToString:@"zh"]) {
        mode = XMGAMELanguageModeCN;
    } else if ([language isEqualToString:@"zh_ft"]){
        mode = XMGAMELanguageModeTC;
    } else if ([language isEqualToString:@"jp"]){
        mode = XMGAMELanguageModeJP;
    } else if ([language isEqualToString:@"kr"]){
        mode = XMGAMELanguageModeKo;
    } else if ([language isEqualToString:@"de"]){
        mode = XMGAMELanguageModeDe;
    } else if ([language isEqualToString:@"ru"]){
        mode = XMGAMELanguageModeRu;
    } else if ([language isEqualToString:@"fr"]){
        mode = XMGAMELanguageModeFr;
    } else if ([language isEqualToString:@"pt"]){
        mode = XMGAMELanguageModePt;
    } else if ([language isEqualToString:@"es"]){
        mode = XMGAMELanguageModeEs;
    } else if ([language isEqualToString:@"it"]){
        mode = XMGAMELanguageModeIt;
    } else if ([language isEqualToString:@"ar"]){
        mode = XMGAMELanguageModeAr;
    } else if ([language isEqualToString:@"vi"]){
        mode = XMGAMELanguageModeVi;
    } else if ([language isEqualToString:@"th"]){
        mode = XMGAMELanguageModeTh;
    }
    
    [NSUserDefaults addValue:@(mode) key:XMGAMELanguageCache];
}

/// 获取存储语言语言
+ (NSString *)sdkGetCacheLanguage{
    
    XMGAMELanguageMode mode = [[NSUserDefaults objectForKey:XMGAMELanguageCache] integerValue];
    
    NSString *language = @"en";
    
    switch (mode) {
        case XMGAMELanguageModeEN: language = @"en";
            break;
        case XMGAMELanguageModeCN: language = @"zh";
            break;
        case XMGAMELanguageModeTC: language = @"zh_ft";
            break;
        case XMGAMELanguageModeJP: language = @"jp";
            break;
        case XMGAMELanguageModeKo: language = @"kr";
            break;
        case XMGAMELanguageModeDe: language = @"de"; /// 德语
            break;
        case XMGAMELanguageModeRu: language = @"ru"; /// 俄语
            break;
        case XMGAMELanguageModeFr: language = @"fr"; /// 法语
            break;
        case XMGAMELanguageModePt: language = @"pt"; /// 葡萄牙语
            break;
        case XMGAMELanguageModeEs: language = @"es"; /// 西班牙语
            break;
        case XMGAMELanguageModeIt: language = @"it"; /// 意大利语
            break;
        case XMGAMELanguageModeAr: language = @"ar"; /// 阿拉伯语
            break;
        case XMGAMELanguageModeVi: language = @"vi"; /// 越南语
            break;
        case XMGAMELanguageModeTh: language = @"th"; /// 泰语
            break;
        default: language = [XMManager sdkGetSystemLanguage];
            break;
    }
    
    return language;
}

/// 获取当前系统语言
+ (NSString *)sdkGetSystemLanguage{
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *language = [languages firstObject];

    if ([language containsString:@"zh-Hans"]) {
        language = @"zh";
    } else if ([language containsString:@"zh-Hant"]){
        language = @"zh_ft";
    } else if ([language containsString:@"ja"]){
        language = @"jp";
    } else if ([language containsString:@"ko"]){
        language = @"kr";
    } else if ([language containsString:@"de"]){
        language = @"de";
    } else if ([language containsString:@"ru"]){
        language = @"ru";
    } else if ([language containsString:@"fr"]){
        language = @"fr";
    } else if ([language containsString:@"pt"]){
        language = @"pt";
    } else if ([language containsString:@"es"]){
        language = @"es";
    } else if ([language containsString:@"it"]){
        language = @"it";
    } else if ([language containsString:@"ar"]){
        language = @"ar";
    } else if ([language containsString:@"vi"]){
        language = @"vi";
    } else if ([language containsString:@"th"]){
        language = @"th";
    } else {
        language = @"en";
    }
    
    return language;
}

+ (NSString *)serverLanguage{
    
    XMGAMELanguageMode mode = [[NSUserDefaults objectForKey:XMGAMELanguageCache] integerValue];
    
    NSString *language;
    if (mode == XMGAMELanguageModeSystem) {
        
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *preferredLanguage = [languages firstObject];
        
        if ([preferredLanguage containsString:@"zh-Hans"]){
            language = @"zh";
        } else if ([preferredLanguage containsString:@"zh-Hant"]){
            language = @"zh_ft";
        } else if ([preferredLanguage containsString:@"ja"]){
            language = @"ja";
        } else if ([preferredLanguage containsString:@"ko"]){
            language = @"ko";
        } else if ([preferredLanguage containsString:@"de"]){
            language = @"de";
        } else if ([preferredLanguage containsString:@"ru"]){
            language = @"ru";
        } else if ([preferredLanguage containsString:@"fr"]){
            language = @"fr";
        } else if ([preferredLanguage containsString:@"pt"]){
            language = @"pt";
        } else if ([preferredLanguage containsString:@"es"]){
            language = @"es";
        } else if ([preferredLanguage containsString:@"it"]){
            language = @"it";
        } else if ([preferredLanguage containsString:@"ar"]){
            language = @"ar";
        } else if ([preferredLanguage containsString:@"vi"]){
            language = @"vi";
        } else if ([preferredLanguage containsString:@"th"]){
            language = @"th";
        } else {
            language = @"en";
        }
    } else {
        switch (mode) {
            case XMGAMELanguageModeEN: language = @"en"; // 英语
                break;
            case XMGAMELanguageModeCN: language = @"zh"; // 简体
                break;
            case XMGAMELanguageModeTC: language = @"zh_ft"; // 繁体
                break;
            case XMGAMELanguageModeJP: language = @"ja"; // 日语
                break;
            case XMGAMELanguageModeKo: language = @"ko"; // 韩语
                break;
            case XMGAMELanguageModeDe: language = @"de"; /// 德语
                break;
            case XMGAMELanguageModeRu: language = @"ru"; /// 俄语
                break;
            case XMGAMELanguageModeFr: language = @"fr"; /// 法语
                break;
            case XMGAMELanguageModePt: language = @"pt"; /// 葡萄牙语
                break;
            case XMGAMELanguageModeEs: language = @"es"; /// 西班牙语
                break;
            case XMGAMELanguageModeIt: language = @"it"; /// 意大利语
                break;
            case XMGAMELanguageModeAr: language = @"ar"; /// 阿拉伯语
                break;
            case XMGAMELanguageModeVi: language = @"vi"; /// 越南语
                break;
            case XMGAMELanguageModeTh: language = @"th"; /// 泰语
                break;
            default: language = @"en";
                break;
        }
    }
    
    return language;
}


+ (NSString *)h5Language{
    XMGAMELanguageMode mode = [[NSUserDefaults objectForKey:XMGAMELanguageCache] integerValue];
    NSString *language;
    if (mode == XMGAMELanguageModeSystem) {
        
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        language = [languages firstObject];
        
        if ([language containsString:@"zh-Hans"]) {
            language = @"zh-Hans";
        } else if ([language containsString:@"zh-Hant"]){
            language = @"zh-Hant";
        } else if ([language containsString:@"ja"]){
            language = @"ja";
        } else if ([language containsString:@"ko"]){
            language = @"ko";
        } else if ([language containsString:@"de"]){
            language = @"de";
        } else if ([language containsString:@"ru"]){
            language = @"ru";
        } else if ([language containsString:@"fr"]){
            language = @"fr";
        } else if ([language containsString:@"pt"]){
            language = @"pt";
        } else if ([language containsString:@"es"]){
            language = @"es";
        } else if ([language containsString:@"it"]){
            language = @"it";
        } else if ([language containsString:@"ar"]){
            language = @"ar";
        } else if ([language containsString:@"vi"]){
            language = @"vi";
        } else if ([language containsString:@"th"]){
            language = @"th";
        } else {
            language = @"EN";
        }
    } else {
        switch (mode) {
            case XMGAMELanguageModeEN: language = @"EN"; /// 英语
                break;
            case XMGAMELanguageModeCN: language = @"zh-Hans"; /// 简体中文
                break;
            case XMGAMELanguageModeTC: language = @"zh-Hant"; /// 繁体中文
                break;
            case XMGAMELanguageModeJP: language = @"ja"; /// 日语
                break;
            case XMGAMELanguageModeKo: language = @"ko"; /// 韩语
                break;
            case XMGAMELanguageModeDe: language = @"de"; /// 德语
                break;
            case XMGAMELanguageModeRu: language = @"ru"; /// 俄语
                break;
            case XMGAMELanguageModeFr: language = @"fr"; /// 法语
                break;
            case XMGAMELanguageModePt: language = @"pt"; /// 葡萄牙语
                break;
            case XMGAMELanguageModeEs: language = @"es"; /// 西班牙语
                break;
            case XMGAMELanguageModeIt: language = @"it"; /// 意大利语
                break;
            case XMGAMELanguageModeAr: language = @"ar"; /// 阿拉伯语
                break;
            case XMGAMELanguageModeVi: language = @"vi"; /// 越南语
                break;
            case XMGAMELanguageModeTh: language = @"th"; /// 泰语
                break;
            default: language = @"EN";
                break;
        }
    }
    return language;
}

+ (NSString *)lanFileWithMode:(XMGAMELanguageMode)mode{
    NSString *language;
    if (mode == XMGAMELanguageModeSystem) {
        
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        language = [languages firstObject];
        
        if ([language containsString:@"zh-Hans"]) {
            language = @"zh-Hans";
        } else if ([language containsString:@"zh-Hant"]){
            language = @"zh-Hant";
        } else if ([language containsString:@"ja"]){
            language = @"ja";
        } else if ([language containsString:@"ko"]){
            language = @"ko";
        } else if ([language containsString:@"de"]){
            language = @"de";
        } else if ([language containsString:@"ru"]){
            language = @"ru";
        } else if ([language containsString:@"fr"]){
            language = @"fr";
        } else if ([language containsString:@"pt"]){
            language = @"pt-BR";
        } else if ([language containsString:@"es"]){
            language = @"es";
        } else if ([language containsString:@"it"]){
            language = @"it";
        } else if ([language containsString:@"ar"]){
            language = @"ar";
        } else if ([language containsString:@"vi"]){
            language = @"vi";
        } else if ([language containsString:@"th"]){
            language = @"th";
        } else {
            language = @"en";
        }
    } else {
        switch (mode) {
            case XMGAMELanguageModeEN: language = @"en"; /// 英语
                break;
            case XMGAMELanguageModeCN: language = @"zh-Hans"; /// 简体中文
                break;
            case XMGAMELanguageModeTC: language = @"zh-Hant"; /// 繁体中文
                break;
            case XMGAMELanguageModeJP: language = @"ja"; /// 日语
                break;
            case XMGAMELanguageModeKo: language = @"ko"; /// 韩语
                break;
            case XMGAMELanguageModeDe: language = @"de"; /// 德语
                break;
            case XMGAMELanguageModeRu: language = @"ru"; /// 俄语
                break;
            case XMGAMELanguageModeFr: language = @"fr"; /// 法语
                break;
            case XMGAMELanguageModePt: language = @"pt-BR"; /// 葡萄牙语
                break;
            case XMGAMELanguageModeEs: language = @"es"; /// 西班牙语
                break;
            case XMGAMELanguageModeIt: language = @"it"; /// 意大利语
                break;
            case XMGAMELanguageModeAr: language = @"ar"; /// 阿拉伯语
                break;
            case XMGAMELanguageModeVi: language = @"vi"; /// 越南语
                break;
            case XMGAMELanguageModeTh: language = @"th"; /// 泰语
                break;
            default: language = @"en";
                break;
        }
    }
    return language;
}

+ (NSString *)localizedString:(NSString *)text{
    
    XMGAMELanguageMode mode = [[NSUserDefaults objectForKey:XMGAMELanguageCache] integerValue];
    NSString *lanFile = [NSBundle lanFileWithMode:mode];
    
    NSBundle *bundle = [NSBundle bundle];
    NSURL *url = [bundle URLForResource:@"XMKit_zhf" withExtension:@"bundle"];
    
    bundle = [NSBundle bundleWithURL:url]; // XMKit_EN.bundle
    
    NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Language/%@.lproj",lanFile]];
    url = [NSURL fileURLWithPath:bundlePath];
    
    bundle = [NSBundle bundleWithURL:url]; // lproj.bundle
    NSString *loca = [bundle localizedStringForKey:text value:nil table:@"Localizable"];
    
    return loca;
}

@end
