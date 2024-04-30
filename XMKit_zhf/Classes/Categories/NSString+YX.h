//
//  NSString+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YX)

/**
 是否是数字
 @return 是否是数字
 */
- (BOOL)isNumber;

/**
 字符串是否有效
 @return 字符串是否有效
 */
- (BOOL)isValidString;

/**
 移除前后空格
 @return 移除后的字符串
 */
- (NSString *)removeSpace;

/// 随机字符串
/// @param length 长度
+ (NSString *)randomWithLength:(NSInteger)length;

/// 时间戳截取
+ (NSString *)timeWithDate;

/// 获取ssid
+ (NSString *)WIFISSID;

+ (NSString *)bodyWithInfo:(NSDictionary *)parameter;

+ (NSString *)hashedValueForAccountName:(NSString *)userAccountName;

@end

NS_ASSUME_NONNULL_END
