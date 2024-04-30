//
//  Header_statis.h
//  XMSDK
//
//  Created by dosear on 2021/8/3.
//  Copyright © 2021 YXQ. All rights reserved.
//

#ifndef Header_statis_h
#define Header_statis_h

// 1、 激活开始：
static NSString *const statis_active_start = @"ios_active_start";
// 2、 激活成功：
static NSString *const statis_active_suc   = @"ios_active_suc";
// 3、 激活失败：
static NSString *const statis_active_fail   = @"ios_active_fail";

// 4、 SDK接收游戏登录调用：
static NSString *const statis_game_start_login = @"ios_game_start_login";
// 5、 SDK登录界面显示：
static NSString *const statis_login_ui_show = @"ios_login_ui_show";
// 6、 SDK登录界面点击关闭：
static NSString *const statis_login_ui_click_close = @"ios_login_ui_click_close";

// 7、 登录按钮点击：
static NSString *const statis_login_ui_click_login = @"ios_login_ui_click_login";

// 8、 忘记密码按钮点击：
static NSString *const statis_login_ui_click_forgot = @"ios_login_ui_click_forgot";

// 9、 apple登录按钮点击：
static NSString *const statis_login_ui_click_apple = @"ios_login_ui_click_apple";

// 10、 FB登录按钮点击：
static NSString *const statis_login_ui_click_facebook = @"ios_login_ui_click_facebook";

// 11、 游客登录按钮点击：
static NSString *const statis_yk_btn_click = @"ios_yk_btn_click";

// 13、游客注册接口开始请求：
static NSString *const statis_yk_request_start = @"ios_yk_request_start";

// 14、游客注册接口请求成功：
static NSString *const statis_yk_request_suc = @"ios_yk_request_suc";

// 15、登录接口开始请求：
static NSString *const statis_login_request_start = @"ios_login_request_start";

// 16、登录接口请求成功：
static NSString *const statis_login_request_suc = @"ios_login_request_suc";

// 17、登录成功回调：
static NSString *const statis_login_suc_callback = @"ios_login_suc_callback";

// 18、apple登录开始：
static NSString *const statis_login_ui_apple_login_start = @"ios_login_ui_apple_login_start";

// 19、apple登录成功：
static NSString *const statis_login_ui_apple_login_suc = @"ios_login_ui_apple_login_suc";

// 20、第三方登录接口请求开始：
static NSString *const statis_third_login_request_start = @"ios_third_login_request_start";

// 21、第三方登录接口请求成功：
static NSString *const statis_third_login_request_suc = @"ios_third_login_request_suc";

// 22、第三方登录接口请求成功调登录成功回调：
static NSString *const statis_third_login_suc_callback = @"ios_third_login_suc_callback";

// 23、FB界面显示：
static NSString *const statis_facebook_ui_show = @"ios_facebook_ui_show";

// 24、FB界面点击关闭：
static NSString *const statis_facebook_ui_click_close = @"ios_facebook_ui_click_close";

// 25、FB登录成功：
static NSString *const statis_facebook_ui_login_suc = @"ios_facebook_ui_login_suc";

// 26、FB登录成功回调：
static NSString *const statis_facebook_ui_login_suc_callback = @"ios_facebook_ui_login_suc_callback";

// 游戏绑定按钮被点击
static NSString *const statis_bind_touch = @"ios_bind_touch";

// 点击邮箱绑定
static NSString *const statis_bind_email_touch = @"ios_bind_email_touch";

// 邮箱绑定成功
static NSString *const statis_bind_email_suc = @"ios_bind_email_suc";

// 点击fb绑定
static NSString *const statis_bind_fb_touch = @"ios_bind_fb_touch";

// fb绑定请求
static NSString *const statis_bind_fb_req = @"ios_bind_fb_req";

// fb绑定成功
static NSString *const statis_bind_fb_suc = @"ios_bind_fb_suc";

// 点击apple绑定
static NSString *const statis_bind_apple_touch = @"ios_bind_apple_touch";

// apple绑定请求
static NSString *const statis_bind_apple_req = @"ios_bind_apple_req";

// apple绑定成功
static NSString *const statis_bind_apple_suc = @"ios_bind_apple_suc";

#endif /* Header_statis_h */
