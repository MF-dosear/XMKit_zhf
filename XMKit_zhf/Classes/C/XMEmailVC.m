//
//  XMEmailVC.m
//  XMSDK
//
//  Created by dosear on 2021/7/30.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMEmailVC.h"
#import "XMManager+BK.h"
#import "XMTextField.h"

@interface XMEmailVC ()<UITextFieldDelegate>

@property (nonatomic, strong) XMTextField *emailField;

@property (nonatomic, strong) XMTextField *codeField;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITextField *currentField;

@end

@implementation XMEmailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:true];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgView.image = IMAGE(LocalizedString(@"sdk_cat")); // 客服

    self.subLabel.text = LocalizedString(@"Link your account to safeguard your progress and play with multiple devices.");
    
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
//    label.text = @"sub-title";
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = true;
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label.textColor = TEXT_COLOR_C;
    [self.view addSubview:label];
    
    label.text = LocalizedString(@"Please enter the account email address to receive the verification code,and check the email folder including the trash box.");
    
    self.emailField = [[XMTextField alloc] initWithMode:YXTextFieldModeEmail];
    [self.view addSubview:self.emailField];
    
    self.codeField = [[XMTextField alloc] initWithMode:YXTextFieldModeCode];
    [self.codeField addSendCodeWithTarget:self action:@selector(sendCode:)];
    [self.view addSubview:self.codeField];
    
    self.emailField.delegate = self;
    self.codeField.delegate = self;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:LocalizedString(@"Confirm") forState:0];
//    [btn setTitle:LocalizedString(@"Confirm") forState:UIControlStateSelected];
    [btn setBackgroundImage:IMAGE(@"sdk_button") forState:0];
//    [btn setBackgroundColor:BtnColor];
    [btn setTitleColor:BtnTitleColor forState:0];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.view addSubview:btn];
    self.confirmBtn = btn;
    
    CGFloat h = 45;
    CGFloat top = 12;
    CGFloat lf = 50;
//    rightView.frame = CGRectMake(0, 0, 100, h);
//    codeBtn.frame = rightView.bounds;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-80);
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(20);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(lf);
        make.right.mas_offset(-lf);
        make.height.mas_equalTo(h);
        make.bottom.mas_equalTo(label.mas_top).offset(-16);
    }];
    
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(lf);
        make.right.mas_offset(-lf);
        make.height.mas_equalTo(h);
        make.bottom.mas_equalTo(btn.mas_top).offset(-20);
    }];
    
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(lf);
        make.right.mas_offset(-lf);
        make.height.mas_equalTo(h);
        make.bottom.mas_equalTo(self.codeField.mas_top).offset(-top);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:true];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.currentField = textField;
    
    return true;
}

/// 发送验证码
- (void)sendCode:(UIButton *)btn{
    
    NSString *email = self.emailField.text;
    if (email.length == 0) {
        [YXHUD showInfoWithText:LocalizedString(@"Email cannot be empty")];
        return;;
    }
    
    WEAKSELF;
    [YXNet getCodeWithEmail:email type:@"bindemail" result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
                        
            [YXHUD showSuccessWithText:LocalizedString(@"Send Code successful") completion:^{
                // 开始读秒
                [btn jk_startTime:120 title:LocalizedString(@"Get Code") waitTittle:@"s"];
                [weakSelf.codeField becomeFirstResponder];
            }];
        } else {
            [YXHUD checkError:error];
        }
    }];
}

- (void)confirmAction{
    
    NSString *email = self.emailField.text;
    NSString *code = self.codeField.text;
    
    if (email.length == 0) {
        [YXHUD showInfoWithText:LocalizedString(@"Email cannot be empty")];
        return;;
    }
    
    if (code.length == 0) {
        [YXHUD showInfoWithText:LocalizedString(@"Code cannot be empty")];
        return;;
    }

    __weak typeof(self) weakself = self;
    [YXNet bindWithEmail:email code:code result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {

            XMConfig *config = [XMConfig sharedXMConfig];
            config.isBindEmail = true;
            
            [YXHUD showSuccessWithText:LocalizedString(@"Bind successful") completion:^{
                [weakself dismiss];
                [XMManager sdkBindBack:true];
                
                [YXStatis uploadAction:statis_bind_email_suc];
                weakself.block();
            }];
        } else {
            [YXHUD checkError:error completion:^{
                
                [XMManager sdkBindBack:false];
            }];
        }
    }];
}

@end
