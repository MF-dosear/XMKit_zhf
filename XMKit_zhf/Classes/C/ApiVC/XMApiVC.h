//
//  XMApiVC.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMCustomVC.h"
#import <WebKit/WebKit.h>

typedef void(^YXApiDismissBlcok)(void);

NS_ASSUME_NONNULL_BEGIN

static NSString * const OVApiPassValue  = @"passValue";
static NSString * const OVApiCloseWeb   = @"closeWeb";
static NSString * const OVApiChangeUser = @"changeUser";
static NSString * const OVApiOpenFB     = @"goFaceBook";
static NSString * const OVApiOpenSafari = @"openSafari";
static NSString * const OVApiCopyCode   = @"copyCode";
static NSString * const OVApiBindPhone  = @"bindPhone";
static NSString * const OVApiPayWay     = @"payWay";
static NSString * const OVApisuperzf    = @"superzfsuccess";
static NSString * const OVApiFBLogin    = @"loginCallback";


@interface XMApiVC : XMCustomVC

@property (nonatomic, copy) NSString *api;

@property (nonatomic, copy) NSString *text;

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic, copy) YXApiDismissBlcok dismissBlock;

@property (nonatomic, assign) BOOL isNavBarHidden;

@property (nonatomic, assign) BOOL isClear;

@end

NS_ASSUME_NONNULL_END
