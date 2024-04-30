//
//  XMTextField.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMTextField.h"

@interface XMTextField() <UITextFieldDelegate>

@property (nonatomic, assign) YXTextFieldMode mode;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *imgName;
@property (nonatomic, assign) UIKeyboardType type;
@property (nonatomic, copy)   NSString *hasPrefix;

@end

@implementation XMTextField

- (NSString *)hasPrefix{
    switch (self.mode) {
        case YXTextFieldModeUserName: return LocalizedString(@"User Name");
        case YXTextFieldModeEmail:    return LocalizedString(@"Email");
        case YXTextFieldModePwd:      return LocalizedString(@"Password");
        case YXTextFieldModeCode:     return LocalizedString(@"Code");
    }
}


- (NSString *)name{
    switch (self.mode) {
        case YXTextFieldModeUserName: return LocalizedString(@"Enter account");
        case YXTextFieldModeEmail:    return LocalizedString(@"Enter Email");
        case YXTextFieldModePwd:      return LocalizedString(@"Enter password");
        case YXTextFieldModeCode:     return LocalizedString(@"Enter code");
    }
}

- (NSString *)imgName{
    switch (self.mode) {
        case YXTextFieldModeUserName:   return @"icon_account";
        case YXTextFieldModeEmail:      return @"icon_email";
        case YXTextFieldModePwd:        return @"icon_pwd";
        case YXTextFieldModeCode:       return @"icon_code_1";
    }
}

- (UIKeyboardType)type{
    switch (self.mode) {
        case YXTextFieldModeUserName:   return UIKeyboardTypeASCIICapable;
        case YXTextFieldModeEmail:      return UIKeyboardTypeASCIICapable;
        case YXTextFieldModePwd:        return UIKeyboardTypeASCIICapable;
        case YXTextFieldModeCode:       return UIKeyboardTypeNumberPad;
    }
}

- (instancetype)initWithMode:(YXTextFieldMode)mode{
    
    self = [super init];
    if (self) {
        self.mode = mode;

        UIView *leftView = [[UIView alloc] init];
        leftView.frame = CGRectMake(0, 0, 12, TEXTHEIGHT);
//
//        UIImageView *imgView = [[UIImageView alloc] init];
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.image = IMAGE(self.imgName);
//        imgView.frame = CGRectMake(0, 0, DEIMGHEIGHT, DEIMGHEIGHT);
//        imgView.center = CGPointMake(20, TEXTHEIGHT / 2);
//        [leftView addSubview:imgView];

        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        UIFont *font = FONTNAME(15);
        
        NSDictionary *info = @{
            NSForegroundColorAttributeName : TEXT_COLOR_B,
            NSFontAttributeName : font
        };
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.name attributes:info];
        self.font = font;
        self.adjustsFontSizeToFitWidth = true;
        self.textColor = TEXT_COLOR_C;
        
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        self.keyboardType = self.type;
        self.returnKeyType = UIReturnKeyDone;
        
        self.delegate = self;
        
        self.layer.borderColor = LINE_COLOR_C.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        
        NSString *lan = [NSBundle serverLanguage];
        if ([lan isEqualToString:@"ar"]) {
            // 阿拉伯语
            self.textAlignment = NSTextAlignmentRight;
            self.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        } else {
            self.textAlignment = NSTextAlignmentLeft;
            self.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        }
    }
    return self;
}

//- (void)drawPlaceholderInRect:(CGRect)rect{
//    NSDictionary *info = @{
//        NSForegroundColorAttributeName : TEXT_COLOR_C,
//        NSFontAttributeName : self.font
//    };
//    [self.placeholder drawInRect:rect withAttributes:info];
//}

//- (UIButton *)addAreaCodeWithTarget:(id)target action:(SEL)action{
//
//    UIView *leftView = [[UIView alloc] init];
//    leftView.frame = CGRectMake(0, 0, 70, TEXTHEIGHT);
////    leftView.backgroundColor = RedColor;
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:LocalizedString(@"Area code") forState:UIControlStateNormal];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    btn.frame = CGRectMake(0, 0, 50, 26);
//    btn.center = CGPointMake(35, TEXTHEIGHT / 2);
//    [btn setTitleColor:TEXT_COLOR_C forState:UIControlStateNormal];
//    btn.titleLabel.font = FONTNAME(12);
//    [btn setBackgroundImage:IMAGE(@"icon_验证码") forState:0];
//    [leftView addSubview:btn];
//    self.areaBtn = btn;
//
//    self.leftView = leftView;
//    self.leftViewMode = UITextFieldViewModeAlways;
//
//    return btn;
//}

- (UIButton *)addSendCodeWithTarget:(id)target action:(SEL)action{
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 90, TEXTHEIGHT);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:LocalizedString(@"Get Code") forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 90, 26);
    btn.center = CGPointMake(40, TEXTHEIGHT / 2);
    [btn setTitleColor:TEXT_COLOR_D forState:UIControlStateNormal];
    btn.titleLabel.font = FONTNAME(14);
//    [btn setBackgroundImage:IMAGE(@"icon_验证码") forState:0];
    btn.titleLabel.adjustsFontSizeToFitWidth = true;
    [rightView addSubview:btn];
    
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    return btn;
}

- (UIButton *)addMoreWithTarget:(id)target action:(SEL)action{
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, TEXTHEIGHT, TEXTHEIGHT);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = rightView.bounds;
    UIImage *imgNormal = [IMAGE(@"icon_down") jk_imageScaledToFitSize:CGSizeMake(DEIMGHEIGHT, DEIMGHEIGHT)];
    UIImage *imgSelected = [IMAGE(@"icon_up") jk_imageScaledToFitSize:CGSizeMake(DEIMGHEIGHT, DEIMGHEIGHT)];
    [btn setImage:imgNormal forState:UIControlStateNormal];
    [btn setImage:imgSelected forState:UIControlStateSelected];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btn];
    
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    return btn;
}

- (void)addEyes{
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, TEXTHEIGHT, TEXTHEIGHT);

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(eyesAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = rightView.bounds;
    UIImage *imgNormal = [IMAGE(@"icon_pwd_close") jk_imageScaledToFitSize:CGSizeMake(DEIMGHEIGHT, DEIMGHEIGHT)];
    UIImage *imgSelected = [IMAGE(@"icon_pwd_open") jk_imageScaledToFitSize:CGSizeMake(DEIMGHEIGHT, DEIMGHEIGHT)];
    [btn setImage:imgNormal forState:UIControlStateNormal];
    [btn setImage:imgSelected forState:UIControlStateSelected];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:btn];
    
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.secureTextEntry = true;
}

- (void)eyesAction:(UIButton *)btn{
    self.secureTextEntry = btn.selected;
    btn.selected = !btn.selected;
}

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//
//    // 绘制图片
//    UIImage *image = IMAGE(@"icon_输入框背景");
//    [image drawInRect:rect];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length <= 0) {
        return true;
    }
    
//    if (self.mode != YXTextFieldModePwd) {
//        if ([string isEqualToString:@" "]) {
//            return false;
//        }
//    }
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // 验证码
    if (self.mode == YXTextFieldModeCode) {
        if (str.length > 6){
            return false;
        }
    }
    
    // 只输入数字
    if (self.mode == YXTextFieldModeCode) {
        return [str isNumber];
    }
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:true];
    return true;;
}

- (BOOL)check{
    
    NSString *text = self.text;
    
    if (text.length == 0) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@",LocalizedString(@"Enter"),self.hasPrefix];
        [YXHUD showInfoWithText:msg];
        return true;
    }
    
    if ([text containsString:@" "]) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@",self.hasPrefix,LocalizedString(@"Cannot contain spaces")];
        [YXHUD showInfoWithText:msg];
        return true;
    }
    
    if (self.mode == YXTextFieldModePwd) {
        
        if (text.length < 6) {
            [YXHUD showInfoWithText:LocalizedString(@"Cannot be less than 6 digits")];
            return true;
        }
        
        if (text.length > 16) {
            [YXHUD showInfoWithText:LocalizedString(@"Cannot be greater than 16 bits")];
            return true;
        }
        
        if ([text containsString:@" "]) {
            [YXHUD showInfoWithText:@"Cannot contain spaces"];
            return YES;
        }
    }
    
    return false;
}

@end
