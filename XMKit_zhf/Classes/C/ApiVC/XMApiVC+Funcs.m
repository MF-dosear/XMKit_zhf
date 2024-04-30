//
//  XMApiVC+Funcs.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/17.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMApiVC+Funcs.h"
#import "YXStatis.h"
#import "XMBaseVC.h"

@implementation XMApiVC (Funcs)

- (void)resetPassWord:(NSString *)newPwd name:(NSString*)name state:(NSString *)state msg:(NSString *)msg{
    
    if ([state isEqualToString:@"1"]) {
        
        if (name.length == 0 || newPwd.length == 0) {
            [YXHUD showErrorWithText:LocalizedString(@"Change pwd failed")];
            return;
        }

        // 存用户
        XMConfig *config = [XMConfig sharedXMConfig];
        config.pwd = newPwd;
        [config saveUser];
    }
    
    if(msg.length > 0){
        
        NSString *text = [msg stringByRemovingPercentEncoding];
        [YXHUD showInfoWithText:text];
    }
}

- (void)fbLoginWithText:(NSString *)text{
    
    NSDictionary *dict = [text jk_dictionaryValue];
    
    NSInteger isnew = [dict[@"isnew"] integerValue];
    
    if(isnew == 0){
        // 注册
        [YXStatis userRegistration:@"Facebook"];
    }
    
    NSInteger login_days = [dict[@"login_days"] integerValue];
    
    if (login_days == 1) {
        [YXStatis userLogin:YXStatisModeSecond];
    }else if (login_days == 3) {
        [YXStatis userLogin:YXStatisModeThree];
    }else if (login_days == 7) {
        [YXStatis userLogin:YXStatisModeSeven];
    }else if (login_days == 14) {
        [YXStatis userLogin:YXStatisModeFourteen];
    }else if (login_days == 30) {
        [YXStatis userLogin:YXStatisModeMonth];
    }
    
    [self loginWithName:dict[@"username"] pwd:dict[@"userpass"]];
}


@end
