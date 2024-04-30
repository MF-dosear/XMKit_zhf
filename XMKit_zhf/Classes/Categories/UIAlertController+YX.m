//
//  UIAlertController+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/19.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "UIAlertController+YX.h"

@implementation UIAlertController (YX)

+ (void)alertTitle:(NSString *)title msg:(NSString *)msg handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"Done") style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:action];
    [SELFVC presentViewController:alert animated:true completion:nil];
}

@end
