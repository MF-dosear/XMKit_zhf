//
//  NSUserDefaults+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (YX)

/// 本地缓存基本数据
+ (void)addValue:(id)value key:(NSString *)key;

/// 获取缓存数据
+ (id)objectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
