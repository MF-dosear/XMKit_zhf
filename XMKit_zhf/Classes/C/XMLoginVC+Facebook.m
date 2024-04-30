//
//  XMLoginVC+Facebook.m
//  XMSDK
//
//  Created by dosear on 2021/7/31.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMLoginVC+Facebook.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation XMLoginVC (Facebook)

/// facebook 登录
- (void)facebookLogin{
    
    [YXStatis uploadAction:statis_login_ui_click_facebook];
    
    [YXStatis uploadAction:statis_facebook_ui_show];
    
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
                [weakSelf loginWithPlatform:3 nickname:token1.userID openId:token1.userID email:@"" token_for_business:token_for_business code:@"" mode:OVLoginModeFacebook];
                
                [YXStatis uploadAction:statis_facebook_ui_login_suc_callback];
            }
        }];
        
    } else {
        
        // facebook登录
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        FBSDKLoginConfiguration *config = [[FBSDKLoginConfiguration alloc] initWithPermissions:@[@"public_profile"] tracking:FBSDKLoginTrackingEnabled];
        
        [login logInFromViewController:self configuration:config completion:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {

            if (error) {
                YXLog(@"Process error");
                
                [YXHUD dismiss];
                
            } else if (result.isCancelled) {
                
                [YXHUD dismiss];
                
                [YXHUD showInfoWithText:LocalizedString(@"Canceled")];
                
                [YXStatis uploadAction:statis_facebook_ui_click_close];
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
                        [weakSelf loginWithPlatform:3 nickname:token2.userID openId:token2.userID email:@"" token_for_business:token_for_business code:@"" mode:OVLoginModeFacebook];
                        
                        [YXStatis uploadAction:statis_facebook_ui_login_suc_callback];
                    }
                }];
            }
        }];
    }
    
}

@end
