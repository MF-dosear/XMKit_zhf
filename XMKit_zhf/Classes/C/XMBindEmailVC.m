//
//  OVBindVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMBindEmailVC.h"
#import "XMManager+BK.h"

@interface XMBindEmailVC ()

@property (nonatomic, strong) XMTextField *textField1;

@property (nonatomic, strong) XMTextField *textField2;

@end

@implementation XMBindEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imgView.image = IMAGE(LocalizedString(@"sdk_cat")); // 客服
    
    // 邮箱
    self.textField1 = [[XMTextField alloc] initWithMode:YXTextFieldModeEmail];
    [self.view addSubview:self.textField1];
    
    // 验证码
    self.textField2 = [[XMTextField alloc] initWithMode:YXTextFieldModeCode];
    [self.textField2 addSendCodeWithTarget:self action:@selector(sendCode:)];
    [self.view addSubview:self.textField2];
    
    XMButton *btn = [XMButton button:LocalizedString(@"Confirm") target:self action:@selector(bindBtnAction)];
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = LocalizedString(@"Reminder");
    label.adjustsFontSizeToFitWidth = true;
    label.font = FONTNAME(13);
    label.numberOfLines = 0;
    label.textColor = TEXT_COLOR_C;
    [self.view addSubview:label];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.titleImage.mas_bottom).offset(45);
    }];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.textField1.mas_bottom).offset(8);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(DEINBTNHEIGHT);
        make.top.mas_equalTo(self.textField2.mas_bottom).offset(30);
    
        make.left.mas_equalTo(MAINBTNLEFTSPACE);
        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(btn.mas_bottom).offset(8);
    }];
}

// 发送验证码
- (void)sendCode:(UIButton *)btn{
    if ([self.textField1 check]) {
        return;
    }
    
    NSString *email = self.textField1.text;
    WEAKSELF;
    [YXNet getCodeWithEmail:email type:@"bindemail" result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
                        
            [YXHUD showSuccessWithText:LocalizedString(@"Send Code successful") completion:^{
                // 开始读秒
                [btn jk_startTime:120 title:LocalizedString(@"Get Code") waitTittle:@"s"];
                [weakSelf.textField2 becomeFirstResponder];
            }];
        } else {
            [YXHUD checkError:error];
        }
    }];
}

// 立即绑定
- (void)bindBtnAction{
    if ([self.textField1 check] || [self.textField2 check]) {
        return;
    }
    
    [self.view endEditing:true];
    
    NSString *email = self.textField1.text;
    NSString *code  = self.textField2.text;

    WEAKSELF;
    [YXNet bindWithEmail:email code:code result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {

            XMConfig *config = [XMConfig sharedXMConfig];
            config.isBindEmail = true;
            
            [YXHUD showSuccessWithText:LocalizedString(@"Bind successful") completion:^{
                [weakSelf pop];
                [XMManager sdkBindBack:true];
                
                [YXStatis uploadAction:statis_bind_email_suc];
            }];
        } else {
            [YXHUD checkError:error completion:^{
                
                [XMManager sdkBindBack:false];
            }];
        }
    }];
}

@end
