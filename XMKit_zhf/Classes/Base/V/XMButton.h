//
//  XMButton.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMButton : UIButton

+ (instancetype)button:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)smallButton:(NSString *)title target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
