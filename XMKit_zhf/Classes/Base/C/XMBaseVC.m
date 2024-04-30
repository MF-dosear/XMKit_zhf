//
//  XMBaseVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMBaseVC.h"
#import "XMProVC.h"

@interface XMBaseVC ()

@end

@implementation XMBaseVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
//    UIImage *image = IMAGE(@"icon_背景");
//    self.imgView = [[UIImageView alloc] initWithImage:image];
//    self.imgView.contentMode = UIViewContentModeScaleToFill;
//    [self.view addSubview:self.imgView];
//
//    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    self.titleImage = [[UIImageView alloc] init];
    self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
//    self.titleImage.backgroundColor = RedColor;
    self.titleImage.image = IMAGE(LocalizedString(@"sdk_cat"));
    [self.view addSubview:self.titleImage];
    
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TITLEHEIGHT);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(12);
    }];
    
    UIImage *backImg = IMAGE(@"sdk_back");
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:backImg forState:0];
    [self.view addSubview:self.backBtn];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.height.width.mas_equalTo(TITLEHEIGHT);
    }];
}

- (void)back{
    [self pop];
}

- (void)dealloc{
    
    YXLog(@"%@对象已经被销毁",NSStringFromClass([self class]));
}

- (void)updateBackBtn{
    
    [self.backBtn setImage:IMAGE(@"sdk_close") forState:0];
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-16);
        make.height.width.mas_equalTo(TITLEHEIGHT);
    }];
}

- (void)openUrl:(NSString *)url text:(NSString *)text{
    XMProVC *vc = [[XMProVC alloc] init];
    vc.url = url;
    vc.text = text;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nvc animated:true completion:nil];
}

@end
