//
//  NSUserDefaults+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "NSUserDefaults+YX.h"

@implementation NSUserDefaults (YX)

+ (void)addValue:(id)value key:(NSString *)key{
    if (value == nil || key == nil) {
    
        YXLog(@"NSUserDefaults参数:key=%@,value=%@不存在，未添加到NSUserDefaults",key,value);
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key{
    if (key == nil) {
        YXLog(@"NSUserDefaults参数:key=%@不存在，未从NSUserDefaults读取到",key);
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@end
