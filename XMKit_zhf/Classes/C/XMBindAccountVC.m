//
//  XMBindAccountVC.m
//  XMSDK
//
//  Created by dosear on 2021/7/30.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindAccountVC.h"
#import "XMManager+BK.h"
#import "XMConfig.h"

#import "XMBindBtn.h"

#import "XMEmailVC.h"
//#import "XMBindEmailVC.h"

#import "XMBindAccountVC+Facebook.h"
#import "XMBindAccountVC+Apple.h"

@interface XMBindAccountVC ()
@end

@implementation XMBindAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self updateBackBtn];
    
    self.imgView.image = IMAGE(LocalizedString(@"sdk_cat")); // 客服
    
//    self.titleLabel.text = LocalizedString(@"Account Settings");

    self.subLabel.text = LocalizedString(@"Link your account to safeguard your progress and play with multiple devices.");
    
    XMBindBtn *fbBtn = [XMBindBtn buttonWithType:UIButtonTypeCustom];
    fbBtn.selected = false;
    [fbBtn setTitle:@"Facebook" forState:0];
    [fbBtn setTitle:@"Facebook" forState:UIControlStateSelected];
    [fbBtn setImage:IMAGE(@"sdk_facebook") forState:0];
    [fbBtn setImage:IMAGE(@"sdk_facebook_0") forState:UIControlStateSelected];
    [fbBtn addTarget:self action:@selector(bindFacebook) forControlEvents:UIControlEventTouchUpInside];
    [fbBtn setTitleColor:WhiteColor forState:0];
    [fbBtn setTitleColor:TEXT_COLOR_A forState:UIControlStateSelected];
    fbBtn.tag = 10002;
    self.fbBtn = fbBtn;
    
    XMBindBtn *appleBtn = [XMBindBtn buttonWithType:UIButtonTypeCustom];
    appleBtn.selected = false;
    [appleBtn setTitle:LocalizedString(@"Sign in with Apple") forState:0];
    [appleBtn setTitle:LocalizedString(@"Sign in with Apple") forState:UIControlStateSelected];
    [appleBtn setImage:IMAGE(@"sdk_apple") forState:0];
    [appleBtn setImage:IMAGE(@"sdk_apple_0") forState:UIControlStateSelected];
    [appleBtn addTarget:self action:@selector(bindApple)
       forControlEvents:UIControlEventTouchUpInside];
    [appleBtn setTitleColor:TEXT_COLOR_D forState:0];
    [appleBtn setTitleColor:TEXT_COLOR_A forState:UIControlStateSelected];
    appleBtn.tag = 10001;
    self.appleBtn = appleBtn;
    
    XMBindBtn *emailBtn = [XMBindBtn buttonWithType:UIButtonTypeCustom];
    emailBtn.selected = false;
    [emailBtn setTitle:LocalizedString(@"E-mail") forState:0];
    [emailBtn setTitle:LocalizedString(@"E-mail") forState:UIControlStateSelected];
    [emailBtn setImage:IMAGE(@"sdk_email") forState:0];
    [emailBtn setImage:IMAGE(@"sdk_email_0") forState:UIControlStateSelected];
    [emailBtn addTarget:self action:@selector(bindEmail) forControlEvents:UIControlEventTouchUpInside];
    [emailBtn setTitleColor:WhiteColor forState:0];
    [emailBtn setTitleColor:TEXT_COLOR_A forState:UIControlStateSelected];
    emailBtn.tag = 10003;
    self.emailBtn = emailBtn;
    
    CGFloat h = 45;
    CGFloat top = 12;
//    CGFloat sp = 0.56;
    CGFloat lf = 50;
    
    XMConfig *config = [XMConfig sharedXMConfig];
    if (config.fb_isopen) {
        
        [self.view addSubview:fbBtn];
        [self.view addSubview:appleBtn];
        [self.view addSubview:emailBtn];
        
        [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(lf);
            make.right.mas_offset(-lf);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(-80);
        }];
        
        [fbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(lf);
            make.right.mas_offset(-lf);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(self.emailBtn.mas_top).offset(-top);
        }];
        
        [appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(lf);
            make.right.mas_offset(-lf);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(self.fbBtn.mas_top).offset(-top);
        }];
        
    } else {
        [self.view addSubview:appleBtn];
        [self.view addSubview:emailBtn];
        
        [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(lf);
            make.right.mas_offset(-lf);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(-80);
        }];
        
        [appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(lf);
            make.right.mas_offset(-lf);
            make.height.mas_equalTo(h);
            make.bottom.mas_equalTo(self.emailBtn.mas_top).offset(-top);
        }];
    }
    
    CGFloat radius = 10;
    
    appleBtn.layer.cornerRadius = radius;
    fbBtn.layer.cornerRadius = radius;
    emailBtn.layer.cornerRadius = radius;
    
    [appleBtn jk_shadowWithColor:TEXT_COLOR_A offset:CGSizeMake(3, 3) opacity:3 radius:3];
    [fbBtn jk_shadowWithColor:TEXT_COLOR_A offset:CGSizeMake(3, 3) opacity:3 radius:3];
    [emailBtn jk_shadowWithColor:TEXT_COLOR_A offset:CGSizeMake(3, 3) opacity:3 radius:3];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    XMConfig *config = [XMConfig sharedXMConfig];
    self.fbBtn.selected = config.isBindFb;
    self.appleBtn.selected = config.isBindApple;
    self.emailBtn.selected = config.isBindEmail;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)back{
    [self dismiss];
}

/// 绑定E-mail
- (void)bindEmail{
    
    [YXStatis uploadAction:statis_bind_email_touch];
        
    XMEmailVC *vc = [[XMEmailVC alloc] init];
    [self presentViewController:vc animated:true completion:nil];
    __weak typeof(self) weakself = self;
    
    vc.block = ^{
        weakself.emailBtn.selected = true;
    };
}

/// 绑定
/// @param platform fb:3,apple:5,google:6
/// @param nickname nickname
/// @param openId openId
/// @param email email
/// @param token_for_business     token_for_business:fb必传
/// @param code 要绑定的账号
- (void)bindWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code btn:(UIButton *)btn{

    [YXNet bindWithPlatform:platform nickname:nickname openId:openId email:email token_for_business:token_for_business code:code result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            btn.selected = true;

            XMConfig *config = [XMConfig sharedXMConfig];
            if (btn == self.appleBtn) {
                config.isBindApple = true;
                [YXStatis uploadAction:statis_bind_apple_suc];
            } else {
                config.isBindFb = true;
                [YXStatis uploadAction:statis_bind_fb_suc];
            }
            
            [YXHUD showSuccessWithText:LocalizedString(@"Bind successful") completion:^{
                [XMManager sdkBindBack:true];
            }];
        } else {
            [YXHUD checkError:error completion:^{
                
                [XMManager sdkBindBack:false];
            }];
        }
    }];
}

@end

