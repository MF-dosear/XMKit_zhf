//
//  CultureServiceVC.m
//  Godoar
//
//  Created by dosear on 2021/6/11.
//  Copyright © 2021 xlsj. All rights reserved.
//

#import "XMServiceVC.h"
#import "XMManager.h"

@interface XMServiceVC ()

//@property (nonatomic, strong) UIImageView *centerImgView;

@property (nonatomic, strong) UIButton *btn1; // messager

@property (nonatomic, strong) UIButton *btn2; // service

@end

@implementation XMServiceVC

- (void)viewDidLoad{
    [super viewDidLoad];

    self.imgView.image = IMAGE(LocalizedString(@"sdk_cat")); // 客服

    [self.subLabel removeFromSuperview];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 setTitle:@"Messager" forState:0];
    [self.btn1 setImage:IMAGE(@"ic_messengercolor") forState:0];
    [self.btn1 setBackgroundImage:IMAGE(@"sdk_button") forState:0];
//    [self.btn1 setBackgroundColor:BtnColor];
    [self.btn1 setTitleColor:BtnTitleColor forState:0];
    self.btn1.layer.cornerRadius = 5;
    self.btn1.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.btn1 addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn2 setTitle:@"service" forState:0];
    [self.btn2 setImage:IMAGE(@"ic_service") forState:0];
    [self.btn2 setBackgroundImage:IMAGE(@"sdk_button") forState:0];
//    [self.btn2 setBackgroundColor:BtnColor];
    [self.btn2 setTitleColor:BtnTitleColor forState:0];
    self.btn2.layer.cornerRadius = 5;
    self.btn2.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.btn2 addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
    
//    self.centerImgView = [[UIImageView alloc] init];
//    self.centerImgView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:self.centerImgView];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = LocalizedString(@"Customer service");
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = true;
    label.font = [UIFont systemFontOfSize:28 weight:UIFontWeightMedium];
    label.textColor = TEXT_COLOR_C;
    [self.view addSubview:label];
    
    CGFloat bottom = 50;
    CGFloat lf = 120;
    CGFloat h = 55;
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottom);
        make.height.mas_equalTo(h);
        make.left.mas_equalTo(lf);
        make.width.mas_equalTo(self.btn2.mas_width);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottom);
        make.height.mas_equalTo(h);
        make.right.mas_equalTo(-lf);
        make.left.mas_equalTo(self.btn1.mas_right).mas_equalTo(20);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(75);
        make.bottom.mas_equalTo(self.btn1.mas_top).offset(-25);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(label.mas_height).multipliedBy(1.3);
    }];
}

- (void)back{
    [self dismiss];
}

- (void)messageAction{
    
    NSString *url = [XMConfig sharedXMConfig].fbmsg;
    if (url.length == 0) {
        url = @"https://www.facebook.com/messages/t/110200735049158";
    }
    [XMManager sdkOpenUrl:url];
}

- (void)serviceAction{

    NSString *url = [XMConfig sharedXMConfig].work_url;
    [XMManager sdkOpenUrl:url];
}

@end
