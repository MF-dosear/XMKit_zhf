//
//  JYLogoView.m
//  SYHGameSDK
//
//  Created by G.E.M on 2018/10/16.
//  Copyright © 2018年 Syh. All rights reserved.
//

#import "YXAuxInfoView.h"
#import "YXAuxView.h"

@interface YXAuxInfoView ()

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;

@end

@implementation YXAuxInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    CGFloat leftSpace = 8;
    CGFloat iPhone6s_width = 375 - leftSpace * 2;
    CGFloat contentView_width = iPhone6s_width * [XMScreen shared].ratio;
    CGFloat contentView_height = iPhone6s_width * 0.6;
    
    UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView_width, contentView_height)];
    CGSize size = [UIScreen mainScreen].bounds.size;
    cv.center = CGPointMake(size.width / 2, size.height / 2);
    [self addSubview:cv];
    
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = FONTNAME(17);
    self.label.text = LocalizedString(@"Show of flip");
    self.label.textColor = [UIColor whiteColor];
    [cv addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 setTitle:LocalizedString(@"Cancel") forState:UIControlStateNormal];
    [self.btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    self.btn1.titleLabel.font = FONTNAME(16);
    [self.btn1 setBackgroundImage:IMAGE(@"icon_按钮_normal") forState:0];
    [cv addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn2 setTitle:LocalizedString(@"Hidden") forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(btnAction2) forControlEvents:UIControlEventTouchUpInside];
    self.btn2.titleLabel.font = FONTNAME(16);
    [self.btn2 setBackgroundImage:IMAGE(@"icon_按钮_seleted") forState:0];
    [cv addSubview:self.btn2];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(MAINBTNLEFTSPACE);
        make.right.mas_equalTo(self.btn2.mas_left).offset(-25);
        make.height.mas_equalTo(MAINBTNHEIGHT);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-MAINBTNLEFTSPACE);
        make.width.mas_equalTo(self.btn1.mas_width);
        make.height.mas_equalTo(MAINBTNHEIGHT);
    }];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cv addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.btn1.mas_top).offset(-8);
    }];
    
    self.imageView.animationImages = @[IMAGE(@"icon_animation_1"),IMAGE(@"icon_animation_2"),IMAGE(@"icon_animation_3"),IMAGE(@"icon_animation_2")];
    self.imageView.animationDuration = 2;
    self.imageView.animationRepeatCount = 0;
}

- (void)show{
    [self.imageView startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }];
}

- (void)hidde{
    [self.imageView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}

- (void)btnAction1{
    [self hidde];
}

- (void)btnAction2{
    [self hidde];
    [YXAuxView hiddenAux];
}

@end
