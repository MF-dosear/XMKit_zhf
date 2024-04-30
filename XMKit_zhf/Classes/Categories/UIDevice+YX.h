//
//  UIDevice+YX.h
//  YXunk
//
//  Created by Hello197309 on 2020/4/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (YX)

/// 设备型号
+ (NSString *)modelName;

/// 设备品牌
+ (NSString *)brand;

+ (NSString *)model;

+ (NSString *)bootTimeInSec;

+ (NSString *)countryCode;

+ (NSString *)language;

+ (NSString *)systemVersion;

+ (NSString *)machine;

+ (NSString *)memory;

+ (NSString *)disk;

+ (NSString *)sysFileTime;

+ (NSString *)model_CAID;

+ (NSString *)timeZone;

+ (NSString* )carrierInfo;

@end

NS_ASSUME_NONNULL_END
