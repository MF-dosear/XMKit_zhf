//
//  XMFatherVC.m
//  XMSDK
//
//  Created by dosear on 2021/4/9.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMFatherVC.h"

#import "YXStatis.h"
#import "XMManager+BK.h"

@interface XMFatherVC ()

@end

@implementation XMFatherVC

- (void)loginWithName:(NSString *)name pwd:(NSString *)pwd{
    
    WEAKSELF;
    [YXNet loginWithName:name pwd:pwd result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {
        
        if (isSuccess == true) {
            // 界面退出
            [weakSelf dismissViewControllerAnimated:true completion:^{
                
                // 登录成功
                [XMManager sdkLoginBack:true];
                
                [YXStatis uploadAction:statis_login_ui_click_close];
            }];
        }
    }];
}

@end
