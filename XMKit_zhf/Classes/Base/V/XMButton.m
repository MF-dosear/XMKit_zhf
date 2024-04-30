//
//  XMButton.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMButton.h"

@implementation XMButton

+ (instancetype)button:(NSString *)title target:(id)target action:(SEL)action{
    XMButton *btn = [XMButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:IMAGE(@"sdk_button") forState:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:WhiteColor forState:0];
    btn.titleLabel.font = FONTNAME(18);
    btn.titleLabel.adjustsFontSizeToFitWidth = true;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (instancetype)smallButton:(NSString *)title target:(id)target action:(SEL)action{
    XMButton *btn = [XMButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    btn.titleLabel.font = FONTNAME(15);
    [btn setTitleColor:TEXT_COLOR forState:0];
    btn.titleLabel.adjustsFontSizeToFitWidth = true;
//    [btn setTitleColor:TEXT_COLOR_B forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
