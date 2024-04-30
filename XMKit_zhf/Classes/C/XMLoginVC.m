//
//  XMLoginVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMLoginVC.h"
#import "XMFindVC.h"

#import "XMManager+BK.h"
#import "XMConfig.h"
#import "XMUsersView.h"

#import "XMCancellationVC.h"
#import "XMUpgradeVC.h"
#import "XMServiceApiVC.h"
#import "XMNavVC.h"

#import "XMLoginVC+Apple.h"
#import "XMLoginVC+Facebook.h"
#import "YXStatis.h"
#import "YXNet+YX.h"

@interface XMLoginVC ()

@property (nonatomic, strong) XMTextField *textField1;

@property (nonatomic, strong) XMTextField *textField2;

@property (nonatomic, strong) XMButton *btn;

@property (nonatomic, strong) XMUsersView *tableView;

@end

@implementation XMLoginVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    XMConfig *config = [XMConfig sharedXMConfig];
    
    NSDictionary *info = [config users].firstObject;
    if (info) {
        self.textField1.text = info[TableLeak_username];
        self.textField2.text = info[TableLeak_pwd];
    }
    
    [[IQKeyboardManager sharedManager] setEnable:true];
    
    [YXNet uploadEventMode:EventMode_accountlogin_show];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self updateBackBtn];
    [self.backBtn removeFromSuperview];
    
    /// 账号
    self.textField1 = [[XMTextField alloc] initWithMode:YXTextFieldModeUserName];
    [self.view addSubview:self.textField1];
    
    /// 密码
    self.textField2 = [[XMTextField alloc] initWithMode:YXTextFieldModePwd];
    [self.textField2 addEyes];
    [self.view addSubview:self.textField2];
    
    NSString *text = LocalizedString(@"Sign in");
    self.btn = [XMButton button:text target:self action:@selector(btnAction)];
    [self.view addSubview:self.btn];
    
    /// 找回密码
    UIButton *forgetBtn = [XMButton smallButton:LocalizedString(@"Forget pwd") target:self action:@selector(findPwd)];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:forgetBtn];
    
    /// 联系客服
    UIButton *serviceBtn = [XMButton smallButton:LocalizedString(@"Customer service") target:self action:@selector(serviceBtnAction)];
    serviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:serviceBtn];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.titleImage.mas_bottom).offset(12);
    }];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.top.mas_equalTo(self.textField1.mas_bottom).offset(8);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.textField2.mas_bottom).offset(4);
        make.height.mas_equalTo(DEIMGHEIGHT);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.width.mas_equalTo(110);
    }];
    
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.textField2.mas_bottom).offset(4);
        make.height.mas_equalTo(DEIMGHEIGHT);
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.width.mas_equalTo(110);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(MAINBTNLEFTSPACE);
        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
        make.height.mas_equalTo(MAINBTNHEIGHT);
        make.top.mas_equalTo(forgetBtn.mas_bottom).offset(8);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.text = LocalizedString(@"Login Method");
    line.font = FONTNAME(12);
    line.textAlignment = NSTextAlignmentCenter;
    line.textColor = TEXT_COLOR_B;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(MAINBTNLEFTSPACE);
        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(self.btn.mas_bottom).offset(15);
    }];
        
    UIFont *font = FONT_12;
    UIButton *appleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appleBtn setImage:IMAGE(@"AppleLogin") forState:0];
    [appleBtn setTitle:LocalizedString(@"Sign in with Apple") forState:0];
    [appleBtn setTitleColor:TEXT_COLOR_D forState:0];
    appleBtn.titleLabel.font = font;
    appleBtn.titleLabel.adjustsFontSizeToFitWidth = true;
    [appleBtn addTarget:self action:@selector(appleLogin) forControlEvents:UIControlEventTouchUpInside];
    appleBtn.imageView.contentMode = UIViewContentModeCenter;
    [appleBtn setBackgroundColor:WhiteColor];
    appleBtn.imageEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
    [self.view addSubview:appleBtn];

    UIButton *facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookBtn setImage:IMAGE(@"facebook登录") forState:0];
    [facebookBtn setTitle:@"Facebook" forState:0];
    facebookBtn.titleLabel.font = font;
    facebookBtn.titleLabel.adjustsFontSizeToFitWidth = true;
    [facebookBtn addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];
    facebookBtn.imageView.contentMode = UIViewContentModeCenter;
    [facebookBtn setBackgroundColor:[UIColor jk_colorWithHexString:@"0061b2"]];
    [self.view addSubview:facebookBtn];
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [guestBtn setImage:IMAGE(@"GuestLogin") forState:0];
    [guestBtn setTitle:LocalizedString(@"Guest") forState:0];
    guestBtn.titleLabel.font = font;
    guestBtn.titleLabel.adjustsFontSizeToFitWidth = true;
    [guestBtn addTarget:self action:@selector(guestLogin) forControlEvents:UIControlEventTouchUpInside];
    guestBtn.imageView.contentMode = UIViewContentModeCenter;
    [guestBtn setBackgroundColor:[UIColor jk_colorWithHexString:@"7cba59"]];
    [self.view addSubview:guestBtn];
    
    
    CGFloat h = 30;
    CGFloat top = 15;
    CGFloat sp = 8;
    CGFloat w = 90;
    CGFloat radius = h / 2.0;
    CGFloat lf = 20;
    
    appleBtn.layer.cornerRadius = radius;
    facebookBtn.layer.cornerRadius = radius;
    guestBtn.layer.cornerRadius = radius;
    
    XMConfig *config = [XMConfig sharedXMConfig];
    if (config.fb_isopen) {
        
        [appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(top);
            make.height.mas_equalTo(h);
            
            make.left.mas_equalTo(lf);
            make.right.mas_equalTo(facebookBtn.mas_left).offset(-sp);
        }];
        
        [facebookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(top);
            make.height.mas_equalTo(h);
            
            make.right.mas_equalTo(guestBtn.mas_left).offset(-sp);
            make.width.mas_equalTo(w);
        }];
        
        [guestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(top);
            make.height.mas_equalTo(h);
            
            make.right.mas_equalTo(-lf);
            make.width.mas_equalTo(w);
        }];
    } else {
        
        [appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(top);
            make.height.mas_equalTo(h);
            
            make.left.mas_equalTo(lf);
            make.right.mas_equalTo(guestBtn.mas_left).offset(-sp);
        }];
        
        [guestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(top);
            make.height.mas_equalTo(h);
            
            make.right.mas_equalTo(-lf);
            make.width.mas_equalTo(appleBtn.mas_width);
        }];
    }
    
    [appleBtn jk_shadowWithColor:TEXT_COLOR_A offset:CGSizeMake(3, 3) opacity:3 radius:3];
    [facebookBtn jk_shadowWithColor:TEXT_COLOR_A offset:CGSizeMake(3, 3) opacity:3 radius:3];
    [guestBtn jk_shadowWithColor:TEXT_COLOR_A offset:CGSizeMake(3, 3) opacity:3 radius:3];
    
    // 更多账号缓存
    UIButton *moreBtn = [self.textField1 addMoreWithTarget:self action:@selector(showAndHide:)];
    
    self.tableView = [[XMUsersView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.alpha = 0;
    [self.view addSubview:self.tableView];
    CGFloat left = TEXTLEFTSPACE;
    CGFloat height = TEXTHEIGHT * 4;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(self.textField1.mas_bottom).offset(2);
        make.height.mas_equalTo(height);
    }];
    
    WEAKSELF;
    self.tableView.block = ^(NSDictionary * _Nonnull user) {
        weakSelf.textField1.text = user[TableLeak_username];
        weakSelf.textField2.text = user[TableLeak_pwd];
        [weakSelf showAndHide:moreBtn];
    };
}

// 展示 或者 隐藏更多用户
- (void)showAndHide:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        // 展示
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 1;
        }];
    } else {
        // 收起
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 0;
        }];
    }
}

- (void)back{
    [self dismissViewControllerAnimated:true completion:^{
        
        [YXStatis uploadAction:statis_login_ui_click_close];
    }];
}

/// 游客 登录
- (void)guestLogin{
    
    [YXStatis uploadAction:statis_yk_btn_click];
    [YXStatis uploadAction:statis_yk_request_start];
    
    WEAKSELF;
    [YXNet regiestAndLoginWithResult:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            [YXStatis uploadAction:statis_yk_request_suc];
            
            // 存储登录数据
            XMConfig *config = [XMConfig sharedXMConfig];
            config.uid       = data[@"uid"];
            config.sid       = data[@"sid"];
            config.user_name = data[@"user_name"];
            config.log_name  = data[@"user_name"];
            config.pwd       = data[@"password"];
            
            // 注册上报
            [YXStatis userRegistration:@"guest"];
            
            // 登录
            [weakSelf loginWithName:config.log_name pwd:config.pwd];
            
            // 注册成功统计
            [YXNet uploadEventMode:EventMode_register_success];
        } else {
            // 失败提示
            [YXHUD checkError:error];
        }
    }];
}

/// 找回密码
- (void)findPwd{
    
    [YXStatis uploadAction:statis_login_ui_click_forgot];

    XMFindVC *vc = [[XMFindVC alloc] init];
    [self push:vc];
    
//    NSArray *list = @[
//        @"XMFindVC",
//        @"XMProVC",
//        @"XMCancellationVC",
//        @"XMUpgradeVC",
//    ];
//
//    Class class = NSClassFromString(list[2]);
//    XMBaseVC *vc = [[class alloc] init];
//    [self push:vc];
}

- (void)serviceBtnAction{
    
    XMServiceApiVC *vc = [[XMServiceApiVC alloc] init];
    [self push:vc];
}

/// 立即登录
- (void)btnAction{
    
    if ([self.textField1 check] || [self.textField2 check]) {
        return;
    }
    
    [YXStatis uploadAction:statis_login_ui_click_login];
    
    [self.view endEditing:true];
    
    NSString *name = self.textField1.text;
    NSString *pwd = self.textField2.text;
    
    [self loginWithName:name pwd:pwd];
}

- (void)loginWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code mode:(OVLoginMode)mode{
    
    [YXStatis uploadAction:statis_third_login_request_start];
    
    WEAKSELF;
    [YXNet loginWithPlatform:platform nickname:nickname openId:openId email:email token_for_business:token_for_business code:code result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            [YXStatis uploadAction:statis_third_login_request_suc];
            
            // 解析数据
            XMConfig *config = [XMConfig sharedXMConfig];
            
            config.adult     = [data[@"adult"] integerValue];
            config.buoyState = data[@"buoyState"];
            config.drurl     = [data[@"drurl"] integerValue];

            config.email        = data[@"email"];
            config.idCard       = data[@"idCard"];
            config.isBindMobile = [data[@"isBindMobile"] boolValue];
            
            config.isOldUser    = [data[@"isOldUser"] boolValue];
            config.is_smrz      = [data[@"is_smrz"] boolValue];
            config.isbindemail  = [data[@"isbindemail"] integerValue];
            
            config.isguest      = [data[@"isguest"] boolValue];
            config.isnew        = [data[@"isnew"] boolValue];
            config.login_days   = [data[@"login_days"] integerValue];
            
            config.mobile    = data[@"mobile"];
            config.nick_name = data[@"nick_name"];
            config.profile   = data[@"profile"];
            
            
            config.sid            = data[@"sid"];
            config.trueName       = data[@"trueName"];
            config.trueNameSwitch = [data[@"trueNameSwitch"] boolValue];
            
            config.uid          = data[@"uid"];
            config.userSex      = [data[@"userSex"] integerValue];
            
            config.isBindFb     = [data[@"isBindFb"] boolValue];
            config.isBindApple  = [data[@"isBindApple"] boolValue];
            config.isBindEmail  = [data[@"isBindEmail"] boolValue];
            
            config.user_name    = data[@"user_name"];
            config.log_name     = data[@"user_name"];
            config.pwd          = data[@"password"];

            if (config.login_days == 1) {
                [YXStatis userLogin:YXStatisModeSecond];
            }else if (config.login_days == 3) {
                [YXStatis userLogin:YXStatisModeThree];
            }else if (config.login_days == 7) {
                [YXStatis userLogin:YXStatisModeSeven];
            }else if (config.login_days == 14) {
                [YXStatis userLogin:YXStatisModeFourteen];
            }else if (config.login_days == 30) {
                [YXStatis userLogin:YXStatisModeMonth];
            }
            
            // 注册上报
            NSString *moth = @"";
            if (mode == OVLoginModeApple) {
                moth = @"Apple";
                [YXStatis uploadAction:statis_login_ui_apple_login_suc];
            } else if (mode == OVLoginModeFacebook){
                moth = @"facebook";
                [YXStatis uploadAction:statis_facebook_ui_login_suc_callback];
            }
            
            // 注册成功统计
            [YXNet uploadEventMode:EventMode_register_success];
            
            if (config.isnew) {
                [YXStatis userRegistration:moth];
            }
            
            // 登录成功提示
            [YXHUD showSuccessWithText:LocalizedString(@"Login successful") completion:^{
                
                [weakSelf dismissViewControllerAnimated:true completion:^{
                    
                    [YXStatis uploadAction:statis_login_ui_click_close];
                    
                    [XMManager sdkLoginBack:true];
                    
                    [YXStatis uploadAction:statis_third_login_suc_callback];
                }];
            }];
            
        } else {
            [YXHUD checkError:error];
        }
    }];
}

@end
