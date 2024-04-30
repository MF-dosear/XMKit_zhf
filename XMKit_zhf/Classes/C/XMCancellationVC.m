//
//  XMCancellationVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMCancellationVC.h"
#import "XMManager+BK.h"
#import "YXAuxView.h"

@interface XMCancellationVC ()

@end

@implementation XMCancellationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backBtn removeFromSuperview];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = LocalizedString(@"Cancel account?");
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    label.numberOfLines = 0;
    label.textColor = TEXT_COLOR_C;
    [self.view addSubview:label];
    
    XMButton *btn1 = [XMButton button:LocalizedString(@"Done") target:self action:@selector(doneAction)];
    [self.view addSubview:btn1];
    
    XMButton *btn2 = [XMButton button:LocalizedString(@"Cancel") target:self action:@selector(cancleAction)];
    [self.view addSubview:btn2];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(MAINBTNHEIGHT);
        make.bottom.mas_equalTo(-55);
    
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(btn2.mas_left).offset(-20);
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(MAINBTNHEIGHT);
        make.bottom.mas_equalTo(-55);
        
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(btn1.mas_width);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TEXTLEFTSPACE);
        make.right.mas_equalTo(-TEXTLEFTSPACE);
        make.top.mas_equalTo(self.titleImage.mas_bottom).offset(20);
        make.bottom.mas_equalTo(btn1.mas_top).offset(0);
    }];
}

// 取消
- (void)cancleAction{
    [self dismissViewControllerAnimated:false completion:^{
        [self.vc present];
    }];
}

// 确定
- (void)doneAction{
    
    [self dismissViewControllerAnimated:false completion:^{
        
        [XMManager sdkLoginOutBack:true];
        
        // 交互不禁用
        YXAuxView *aux = [YXAuxView sharedAux];
        aux.userInteractionEnabled = true;
    }];
}

@end
