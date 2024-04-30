//
//  LYSEL.m
//  Pion
//
//  Created by G.E.M on 2023/8/5.
//  Copyright © 2020 pengchao. All rights reserved.
//

#import "LYSEL.h"

@implementation LYSEL

+ (SEL)selFromName:(NSString *)name{
    
    if (name.length == 0) {
        
        return nil;
    } else {
        
        return NSSelectorFromString(name);
    }
}

+ (NSString *)nameFromSEL:(SEL)sel{
    if (sel == nil) {
        return nil;
    } else {
        return NSStringFromSelector(sel);
    }
}

+ (void)logWithObj:(id)obj ints:(int)ints floats:(float)floats{
    NSLog(@"obj = %@ \nints = %d \nfloats = %lf",obj,ints,floats);
}

@end
