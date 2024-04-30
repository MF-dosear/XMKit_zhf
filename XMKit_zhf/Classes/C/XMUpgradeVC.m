//
//  XMUpgradeVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/13.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMUpgradeVC.h"
#import "XMManager.h"

@interface XMUpgradeVC ()

@end

@implementation XMUpgradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backBtn removeFromSuperview];
//    [self.backBtn setImage:IMAGE(@"icon_nav_关闭") forState:0];
    
    XMButton *btn = [XMButton button:LocalizedString(@"Upgrade now") target:self action:@selector(btnAction)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(MAINBTNHEIGHT);
        make.bottom.mas_equalTo(-50);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = IMAGE(@"icon_upgrade");
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImage.mas_bottom).offset(30);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(btn.mas_top).offset(-16);
    }];
}

/// 升级
- (void)btnAction{
    
    [XMManager sdkOpenUrl:self.url];
}


@end
