//
//  XMBindAccountVC.h
//  XMSDK
//
//  Created by dosear on 2021/7/30.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMBindAccountVC : XMBindBaseVC

@property (nonatomic, strong) UIButton *fbBtn;

@property (nonatomic, strong) UIButton *appleBtn;

@property (nonatomic, strong) UIButton *emailBtn;

/// 绑定
/// @param platform fb:3,apple:5,google:6
/// @param nickname nickname
/// @param openId openId
/// @param email email
/// @param token_for_business     token_for_business:fb必传
/// @param code 要绑定的账号
- (void)bindWithPlatform:(NSInteger)platform nickname:(NSString *)nickname openId:(NSString *)openId email:(NSString *)email token_for_business:(NSString *)token_for_business code:(NSString *)code btn:(UIButton *)btn;

@end

NS_ASSUME_NONNULL_END
