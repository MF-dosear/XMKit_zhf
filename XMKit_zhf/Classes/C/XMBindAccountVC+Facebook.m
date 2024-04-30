//
//  XMBindAccountVC+Facebook.m
//  XMSDK
//
//  Created by dosear on 2021/8/2.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindAccountVC+Facebook.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation XMBindAccountVC (Facebook)

/// 绑定facebook
- (void)bindFacebook{
    
    [YXStatis uploadAction:statis_bind_fb_touch];
    
    [YXHUD show];
    
    WEAKSELF;
    FBSDKAccessToken *token1 = [FBSDKAccessToken currentAccessToken];
    if (FBSDKAccessToken.isCurrentAccessTokenActive) {
           
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=token_for_business" parameters:@{} HTTPMethod:@"GET"];
        
        [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            
            [YXHUD dismiss];
            
            if (error) {
                [YXHUD showErrorWithText:error.description];
            } else {
                NSString *token_for_business = result[@"token_for_business"];
                
                [weakSelf bindWithPlatform:3 nickname:token1.userID openId:token1.userID email:@"" token_for_business:token_for_business code:@"" btn:weakSelf.fbBtn];
                
                [YXStatis uploadAction:statis_bind_fb_req];
            }
        }];
        
    } else {
        
        // facebook登录
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        FBSDKLoginConfiguration *config = [[FBSDKLoginConfiguration alloc] initWithPermissions:@[@"public_profile"] tracking:FBSDKLoginTrackingEnabled];
        
        [login logInFromViewController:self configuration:config completion:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {

            if (error) {
                [YXHUD dismiss];
                
                YXLog(@"Process error");
            } else if (result.isCancelled) {
                [YXHUD dismiss];
                
                [YXHUD showInfoWithText:LocalizedString(@"Canceled")];
            } else {
                YXLog(@"Logged in ,userid = %@", result.token.userID);

                FBSDKAccessToken *token2 = result.token;

                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=token_for_business" parameters:@{} tokenString:token2.tokenString version:nil HTTPMethod:@"GET"];

                [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
                    
                    [YXHUD dismiss];
                    
                    if (error) {
                        [YXHUD showErrorWithText:error.description];
                    } else {
                        NSString *token_for_business = result[@"token_for_business"];
                        [weakSelf bindWithPlatform:3 nickname:token2.userID openId:token2.userID email:@"" token_for_business:token_for_business code:@"" btn:weakSelf.fbBtn];
                        
                        [YXStatis uploadAction:statis_bind_fb_req];
                    }
                }];
            }
        }];
    }
    
}

@end
