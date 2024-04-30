//
//  XMServiceApiVC.m
//  XMSDK
//
//  Created by dosear on 2021/8/17.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMServiceApiVC.h"
#import "XMManager+Apple.h"
#import "YXNetApi.h"

@interface XMServiceApiVC ()

//@property (nonatomic, strong) UIButton *btn1; // messager
//
//@property (nonatomic, strong) UIButton *btn2; // service

@end

@implementation XMServiceApiVC

//- (void)viewDidLoad{
//    [super viewDidLoad];
//
//    if (self.isDismiss) {
//        [self updateBackBtn];
//    }
//
//
//    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btn1 setTitle:@"Messager" forState:0];
//    [self.btn1 setImage:IMAGE(@"ic_messengercolor") forState:0];
//    [self.btn1 setBackgroundImage:IMAGE(@"sdk_button") forState:0];
////    [self.btn1 setBackgroundColor:BtnColor];
//    [self.btn1 setTitleColor:BtnTitleColor forState:0];
//    self.btn1.layer.cornerRadius = 5;
//    self.btn1.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    [self.btn1 addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btn1];
//
//    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btn2 setTitle:@"service" forState:0];
//    [self.btn2 setImage:IMAGE(@"ic_service") forState:0];
//    [self.btn2 setBackgroundImage:IMAGE(@"sdk_button") forState:0];
////    [self.btn2 setBackgroundColor:BtnColor];
//    [self.btn2 setTitleColor:BtnTitleColor forState:0];
//    self.btn2.layer.cornerRadius = 5;
//    self.btn2.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    [self.btn2 addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btn2];
//
//    CGFloat bottom = 25;
//    CGFloat h = 45;
//    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-bottom);
//        make.height.mas_equalTo(h);
//        make.left.mas_equalTo(MAINBTNLEFTSPACE);
//        make.width.mas_equalTo(self.btn2.mas_width);
//    }];
//
//    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-bottom);
//        make.height.mas_equalTo(h);
//        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
//        make.left.mas_equalTo(self.btn1.mas_right).mas_equalTo(20);
//    }];
//
//    YYLabel *label = [[YYLabel alloc] init];
//    label.numberOfLines = 0;
//    [self.view addSubview:label];
//
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(MAINBTNLEFTSPACE);
//        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
//        make.top.mas_equalTo(self.titleImage.mas_bottom);
//        make.bottom.mas_equalTo(self.btn1.mas_top);
//    }];
//
//    // 如果您有任何問題或者疑問，歡迎通過下麵的鏈接或者郵箱與我們聯繫。
//    NSString *text = [NSString stringWithFormat:@"★ %@\n★ Facebook：%@\n★ Email：%@",LocalizedString(@"If you have any questions or questions, please contact us through the following link or email"),Service_API,Service_Email];
//
//    NSMutableAttributedString *att  = [[NSMutableAttributedString alloc] initWithString:text];
//    att.yy_lineSpacing = 5;
//    att.yy_font = FONTNAME(15);
//    att.yy_color = TEXT_COLOR_C;
//
//    UIColor *color = ProColor;
//
//    NSRange rang1 = [text rangeOfString:Service_API];
//    [att yy_setTextHighlightRange:rang1 color:color backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//
//        // facebook
//        [XMManager sdkOpenUrl:Service_API];
//    }];
//
//    NSRange rang2 = [text rangeOfString:Service_Email];
//    [att yy_setTextHighlightRange:rang2 color:color backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//
//        // email
//        [XMManager copyWithText:Service_Email msg:LocalizedString(@"Email")];
//    }];
//
//    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(2) color:ProColor];
//    [att yy_setTextUnderline:decoration range:rang1];
//    [att yy_setTextUnderline:decoration range:rang2];
//
//    label.attributedText = att;
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.backBtn removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = LocalizedString(@"If you have any questions or questions, please contact us through the following link or email");
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:IMAGE(@"se_fb") forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(facebook) forControlEvents:UIControlEventTouchUpInside];
    btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:IMAGE(@"se_me") forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];
    btn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setImage:IMAGE(@"se_kf") forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(service) forControlEvents:UIControlEventTouchUpInside];
    btn3.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setImage:IMAGE(@"se_yx") forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(email) forControlEvents:UIControlEventTouchUpInside];
    btn4.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:btn4];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:LocalizedString(@"Done") forState:0];
    [btn setBackgroundImage:IMAGE(@"sdk_button") forState:0];
    [btn setTitleColor:BtnTitleColor forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btn.mas_top).offset(-30);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(btn2.mas_width);
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn1.mas_centerY);
        make.height.mas_equalTo(btn1.mas_height);
        make.left.mas_equalTo(btn1.mas_right).offset(8);
        make.width.mas_equalTo(btn3.mas_width);
    }];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn1.mas_centerY);
        make.height.mas_equalTo(btn1.mas_height);
        make.left.mas_equalTo(btn2.mas_right).offset(8);
        make.width.mas_equalTo(btn4.mas_width);
    }];
    
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn1.mas_centerY);
        make.height.mas_equalTo(btn1.mas_height);
        make.left.mas_equalTo(btn3.mas_right).offset(8);
        make.right.mas_equalTo(-20);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MAINBTNLEFTSPACE);
        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
        make.top.mas_equalTo(self.titleImage.mas_bottom);
        make.bottom.mas_equalTo(btn1.mas_top);
    }];
}

- (void)back{
    if (self.isDismiss) {
        [self dismiss];
    } else {
        [self pop];
    }
}

- (void)facebook{
    NSString *url = [XMConfig sharedXMConfig].fbfans;
    if (url.length == 0) {
        url = Service_FbFans;
    }
    [XMManager sdkOpenUrl:url];
}

- (void)message{
    NSString *url = [XMConfig sharedXMConfig].fbmsg;
    if (url.length == 0) {
        url = Service_Messenger;
    }
    [XMManager sdkOpenUrl:url];
}

- (void)service{
    NSString *url = [XMConfig sharedXMConfig].work_url;
    if (url.length == 0) {
        url = Service_server;
    }
    [XMManager sdkOpenUrl:url];
}

- (void)email{
    NSString *url = [XMConfig sharedXMConfig].emails;
    if (url.length == 0) {
        url = Service_Email;
    }
    [XMManager copyWithText:url msg:@"email"];
}

@end
