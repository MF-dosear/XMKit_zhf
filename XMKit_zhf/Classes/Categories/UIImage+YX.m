//
//  UIImage+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "UIImage+YX.h"

@implementation UIImage (YX)

+ (UIImage *)imageBundleNamed:(NSString *)bundleName {
    
    NSBundle *bundle = [NSBundle bundle];
    NSURL *url = [bundle URLForResource:@"XMKit_zhf" withExtension:@"bundle"];
    
    bundle = [NSBundle bundleWithURL:url];
    
    UIImage *image = [UIImage imageNamed:bundleName inBundle:bundle withConfiguration:nil];
    return image;
}

@end
