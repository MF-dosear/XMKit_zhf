//
//  XMLoginVC+Apple.m
//  XMSDK
//
//  Created by dosear on 2021/7/31.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMLoginVC+Apple.h"

@implementation XMLoginVC (Apple)

/// apple 登录
- (void)appleLogin{
    
    [YXStatis uploadAction:statis_login_ui_click_apple];
    
    [YXStatis uploadAction:statis_login_ui_apple_login_start];
    
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    } else {
        [YXHUD showInfoWithText:LocalizedString(@"The system version does not support Apple login")];
    }
}

#pragma mark - ASAuthorizationControllerDelegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *openid = credential.user;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding] ? : @"";

        [self loginWithPlatform:6 nickname:fullName.nickname openId:openid email:@"" token_for_business:@"" code:authorizationCode mode:OVLoginModeApple];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        
        [YXHUD showInfoWithText:LocalizedString(@"The authorization information is inconsistent")];
    } else{
        YXLog(@"/Users/edz/Desktop/H-GAME/XMSDK/XMSDK/C/XMLoginVC+Apple.m授权信息均不符");
        [YXHUD showInfoWithText:LocalizedString(@"The authorization information is inconsistent")];
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSString *errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"Canceled";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"Failed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"Invalid Response";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"Not Handled";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"Unknown";
            break;
        default:
            break;
    }
    
    [YXHUD showInfoWithText:LocalizedString(errorMsg)];
}
#pragma mark - ASAuthorizationControllerPresentationContextProviding
// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
API_AVAILABLE(ios(13.0)){
    // 返回window
    return self.view.window;
}


@end
