//
//  YXError.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "YXError.h"

@implementation YXError

+ (instancetype)initWithCode:(NSString *)code{
    YXError *error = [[YXError alloc] init];
    error.code = code;
    return error;
}

@end
