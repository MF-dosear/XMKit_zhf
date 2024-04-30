//
//  LYSEL.h
//  Pion
//
//  Created by G.E.M on 2023/8/5.
//  Copyright © 2020 pengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYSEL : NSObject

/// 获取sel
/// @param name 方法名
+ (SEL)selFromName:(NSString *)name;

/// 获取方法名
/// @param sel sel
+ (NSString *)nameFromSEL:(SEL)sel;

/// 打印参数
/// @param obj 类
/// @param ints int
/// @param floats float
+ (void)logWithObj:(id)obj ints:(int)ints floats:(float)floats;

@end

NS_ASSUME_NONNULL_END
