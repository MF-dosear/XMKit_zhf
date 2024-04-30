

//
//  XMFindVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMFindVC.h"
#import "XMConfig.h"

@interface XMFindVC ()

@property (nonatomic, strong) XMTextField *textField1;

@property (nonatomic, strong) XMTextField *codeTextField;

@property (nonatomic, strong) XMTextField *pwdTextField;

@property (nonatomic, strong) XMButton *btn;

@property (nonatomic, copy) NSString *username;

@end

@implementation XMFindVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    XMConfig *config = [XMConfig sharedXMConfig];
    if (config.email.length > 0) {
        self.textField1.text = config.email;
    }
    
    [[IQKeyboardManager sharedManager] setEnable:true];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 邮箱
    self.textField1 = [[XMTextField alloc] initWithMode:YXTextFieldModeEmail];
    [self.view addSubview:self.textField1];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.titleImage.mas_bottom).offset(15);
    }];
    
    // 验证码
    self.codeTextField = [[XMTextField alloc] initWithMode:YXTextFieldModeCode];
    [self.codeTextField addSendCodeWithTarget:self action:@selector(sendCode:)];
    [self.view addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.textField1.mas_bottom).offset(8);
    }];
    
    // 密码
    self.pwdTextField = [[XMTextField alloc] initWithMode:YXTextFieldModePwd];
    [self.pwdTextField addEyes];
    [self.view addSubview:self.pwdTextField];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(8);
    }];
    
    self.btn = [XMButton button:LocalizedString(@"Change done") target:self action:@selector(btnAction)];
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(MAINBTNLEFTSPACE);
        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
        make.height.mas_equalTo(MAINBTNHEIGHT);
        make.top.mas_equalTo(self.pwdTextField.mas_bottom).offset(25);
    }];
}

// 发送验证码
- (void)sendCode:(UIButton *)btn{
    if ([self.textField1 check]) {
        return;
    }
        
    NSString *email = self.textField1.text;
    WEAKSELF;
    [YXNet getCodeWithEmail:email type:@"resetpass" result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            weakSelf.username = data[@"user_name"];
                        
            [YXHUD showSuccessWithText:LocalizedString(@"Send Code successful") completion:^{
                // 开始读秒
                [btn jk_startTime:120 title:LocalizedString(@"Get Code") waitTittle:@"s"];
                [weakSelf.codeTextField becomeFirstResponder];
            }];
        } else {
            [YXHUD checkError:error];
        }
    }];
}

// 找回密码
- (void)btnAction{
    if ([self.textField1 check] || [self.codeTextField check] || [self.pwdTextField check]) {
        return;
    }
    
    [self.view endEditing:true];
    
    NSString *email = self.textField1.text;
    NSString *code  = self.codeTextField.text;
    NSString *pwd  = self.pwdTextField.text;
    
    WEAKSELF;
    [YXNet resetWithEmail:email code:code name:self.username pwd:pwd result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            [YXHUD showSuccessWithText:LocalizedString(@"Get and loging") completion:^{
                
                [weakSelf loginWithName:email pwd:pwd];
            }];
        } else {
            [YXHUD checkError:error];
        }
    }];
}

@end
