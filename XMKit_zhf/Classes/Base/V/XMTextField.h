//
//  XMTextField.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXTextFieldMode) {
    YXTextFieldModeUserName,
    YXTextFieldModeEmail,
    YXTextFieldModePwd,
    YXTextFieldModeCode
};

@interface XMTextField : UITextField

- (instancetype)initWithMode:(YXTextFieldMode)mode;

- (UIButton *)addSendCodeWithTarget:(id)target action:(SEL)action;

- (UIButton *)addMoreWithTarget:(id)target action:(SEL)action;

- (void)addEyes;

- (BOOL)check;

@end

NS_ASSUME_NONNULL_END
