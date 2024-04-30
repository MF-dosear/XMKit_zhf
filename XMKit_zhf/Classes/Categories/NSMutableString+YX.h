//
//  NSMutableString+YX.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/12.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (YX)

/// 特殊字符处理
- (NSString *)encodeUrl;

@end

NS_ASSUME_NONNULL_END
