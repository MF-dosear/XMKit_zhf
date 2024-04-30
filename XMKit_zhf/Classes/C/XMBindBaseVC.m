//
//  XMBindBaseVC.m
//  XMSDK
//
//  Created by dosear on 2021/7/30.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindBaseVC.h"

@interface XMBindBaseVC ()

@end

@implementation XMBindBaseVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *bk = [[UIImageView alloc] init];
//    bk.image = IMAGE(@"启动图");
//    bk.contentMode = UIViewContentModeScaleAspectFill;
//    bk.layer.masksToBounds = true;
//    [self.view addSubview:bk];
    
//    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:IMAGE(@"sdk_close") forState:0];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.width.mas_equalTo(44);
        make.top.mas_equalTo(44);
    }];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.titleImage.backgroundColor = RedColor;
    [self.view addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(44);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"sub-title";
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = true;
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label.textColor = TEXT_COLOR_C;
    [self.view addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(20);
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.height.mas_equalTo(40);
    }];
    self.subLabel = label;
    
}

@end
