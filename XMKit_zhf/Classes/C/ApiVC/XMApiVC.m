//
//  XMApiVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMApiVC.h"
#import "XMApiVC+Cache.h"
#import "XMApiVC+KeyBoard.h"
#import "XMApiVC+Alert.h"
#import "XMApiVC+Funcs.h"

#import "XMManager+Apple.h"

#import "YXAuxView.h"
#import "XMCancellationVC.h"

#import "XMManager+BK.h"

#import "XMInfos.h"

#import <AppsFlyerLib/AppsFlyerLib.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface XMApiVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, copy) NSArray *funcs;

@end

@implementation XMApiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加Wk
    [self addWebView];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"sdk_close") style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = closeItem;
    
    self.title = self.text;
    
    NSURL *url = [NSURL URLWithString:self.api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    [self.webView loadRequest:request];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:false completion:^{
        
        // 移除交互
        for (NSString *func in self.funcs) {
            [self.webView.configuration.userContentController removeScriptMessageHandlerForName:func];
        }
        
        if (self.dismissBlock) {
            self.dismissBlock();
        }
        
        // 取消禁用
        [YXAuxView sharedAux].userInteractionEnabled = true;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.isNavBarHidden];
}

- (NSArray *)funcs{
    if (_funcs == nil) {
        
       _funcs = @[
           OVApiPassValue  ,
           OVApiCloseWeb   ,
           OVApiChangeUser ,
           OVApiOpenFB     ,
           OVApiOpenSafari ,
           OVApiCopyCode   ,
           OVApiBindPhone  ,
           OVApiPayWay     ,
           OVApisuperzf    ,
           OVApiFBLogin
       ];
    }
    return _funcs;
}

- (void)addWebView{
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    // 注入js方法
    for (NSString *funName in self.funcs) {
        [userContentController addScriptMessageHandler:self name:funName];
    }

    config.userContentController = userContentController;

    // 进行偏好设置
    WKPreferences *preferences = [[WKPreferences alloc] init];
    //preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //preferences.minimumFontSize = 40.0;
    // 不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = true;
    // 是否支持JavaScript
    preferences.javaScriptEnabled = true;
    [preferences setValue:@(true) forKey:@"allowFileAccessFromFileURLs"];
    config.preferences = preferences;
    config.allowsInlineMediaPlayback = true;
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = false;
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.scrollView.showsVerticalScrollIndicator = false;
    webView.scrollView.showsHorizontalScrollIndicator = false;
    
    if (self.isClear) {
        webView.backgroundColor = [UIColor clearColor];
        webView.scrollView.backgroundColor = [UIColor clearColor];
        webView.opaque = false;
    } else {
        webView.backgroundColor = WhiteColor;
    }

    webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.webView = webView;
    
    // 添加键盘处理
    [self addKeyBoardNoti];
}

- (void)dealloc{
    
    [self removeKeyBoardNoti];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //可以通过navigationAction.navigationType 获取跳转类型，如新链接、后退等
    NSURL *URL = navigationAction.request.URL;
    //判断URL是否符合自定义的URL Scheme
    if ([URL.scheme isEqualToString:@"https"] || [URL.scheme isEqualToString:@"http"]) {
        
        // 重置密码
        NSMutableDictionary* dict = [self parseURL:navigationAction.request.URL.query];
        
        NSString *dod = dict[@"do"];
        if ([dod isEqualToString:@"pwd"]) {
            
            NSString *pwd = dict[@"pwd"];
            NSString *userName = dict[@"userName"];
            NSString *state = dict[@"state"];
            NSString *msg = dict[@"msg"];
            
            [self resetPassWord:pwd name:userName state:state msg:msg];
        }
    } else {
        
        /// 不是http 就跳转
        if (@available(iOS 10.0, *)) {
            NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @(false)};
            [[UIApplication sharedApplication] openURL:URL options:options completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -
// 解析url
- (NSMutableDictionary*)parseURL:(NSString*)url{
    //将字符串切割成数组
    NSArray *query = [url componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    //
    for (int idx = 0; idx < query.count; ++idx) {
        //
        NSArray *arr =[query[idx] componentsSeparatedByString:@"="];
        if(arr&&arr.count == 2) [dict setValue:arr[1] forKey:arr[0]];
    }
    return dict;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *name = message.name;
    
    if ([name isEqualToString:OVApiPassValue]) {
        // 提示框
        NSString *text = [NSString stringWithFormat:@"%@",message.body];
        if (text.length > 0) {
            [YXHUD showInfoWithText:text];
        }
    } else if ([name isEqualToString:OVApiCloseWeb]) {
        // 关闭
        [self dismiss];
    } else if ([name isEqualToString:OVApiChangeUser]) {
        // 切换账号
        [self loginOut];
    } else if ([name isEqualToString:OVApiOpenFB]) {
        // 打开FB
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",message.body[@"url"]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if ([name isEqualToString:OVApiOpenSafari]) {
        // 浏览器打开
        if ([message.body isKindOfClass:[NSString class]] && message.body != nil) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.body]];
        }
    } else if ([name isEqualToString:OVApiCopyCode]) {
        // 复制
        NSString *text = [NSString stringWithFormat:@"%@",message.body];
        if (text.length > 0) {
            [XMManager copyWithText:text msg:LocalizedString(@"Message")];
        }
    } else if ([name isEqualToString:OVApiBindPhone]) {
        
    } else if([name isEqualToString:OVApiPayWay]){
        // 网页支付
        [self applePsy:message.body];
    } else if ([name isEqualToString:OVApisuperzf]) {
        // 统计
        NSString *price = [XMInfos sharedXMInfos].price;
        [[AppsFlyerLib shared] logEvent:AFEventPurchase withValues: @{AFEventParamRevenue:price}];
//        [[FBSDKAppEvents shared] logEvent:AFEventPurchase parameters:@{@"item_price":price}];
        // 销毁界面
        [self dismiss];
        
    } else if ([name isEqualToString:OVApiFBLogin]) {
        // fb登录
        [self fbLoginWithText:message.body];
    }
}

/// 注销
- (void)loginOut{
    
    XMCancellationVC *vc = [[XMCancellationVC alloc] init];
    vc.vc = self;
    
    [self dismissViewControllerAnimated:false completion:^{
        
        [vc present];
    }];
}

#pragma mark - 获取订单
- (void)applePsy:(NSDictionary *)info{
    YXLog(@"info = %@",info);
    
    NSString *name = info[@"name"];
    NSString *channel = info[@"id"];
    
    NSString *price = info[@"amount"];
    
    [YXNet getOrderWithChannel:channel name:name price:price result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess) {
            
            // 统计 生成订单
    //            [YXStatis sdkOrder];
            
            // 获取支付单号
            XMConfig *config = [XMConfig sharedXMConfig];
            config.goodbye = data[@"pay_url"];
            config.orderID = data[@"order_id"];
            
            if ([channel isEqualToString:@"5"] || [channel isEqualToString:@"11"] || channel == nil) {
            
                // 苹果
                [self dismissViewControllerAnimated:true completion:^{
                    
                    // 移除交互
                    for (NSString *func in self.funcs) {
                        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:func];
                    }
                    
                    // 取消禁用
                    [YXAuxView sharedAux].userInteractionEnabled = true;
                    
                    // 支付
                    XMInfos *info = [XMInfos sharedXMInfos];
                    [XMManager toPsyWithProductId:info.goodsID];
                }];
            } else {
                // 其他
                [self dismissViewControllerAnimated:true completion:^{
                    
                    XMApiVC *vc = [[XMApiVC alloc] init];
                    vc.api = config.goodbye;
                    vc.text = name;
                    
                    // 界面跳转
                    [vc present];
                }];
            }
        } else {
            // 支付失败
            [YXHUD showErrorWithText:error.describe completion:^{
                [XMManager sdkPsyBack:false];
            }];
        }
    }];
}

@end
