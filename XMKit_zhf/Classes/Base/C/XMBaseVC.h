//
//  XMBaseVC.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMFatherVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMBaseVC : XMFatherVC

//@property (nonatomic, strong) UIImageView *imgView; // 背景

@property (nonatomic, strong) UIImageView *titleImage; // 标题

@property (nonatomic, strong) UIButton *backBtn; // 返回

/// pop返回模式
- (void)back;

- (void)updateBackBtn;

- (void)openUrl:(NSString *)url text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
