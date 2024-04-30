//
//  YXHUD.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "SVProgressHUD.h"
#import "YXError.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHUD : NSObject

+ (void)show;

+ (void)dismiss;

+ (void)showInfoWithText:(NSString*)text;

+ (void)showWarnWithText:(NSString*)text;

+ (void)showSuccessWithText:(NSString*)text;

+ (void)showErrorWithText:(NSString*)text;

+ (void)showInfoWithText:(NSString*)text completion:(SVProgressHUDDismissCompletion)completion;

+ (void)showWarnWithText:(NSString*)text completion:(SVProgressHUDDismissCompletion)completion;

+ (void)showSuccessWithText:(NSString*)text completion:(SVProgressHUDDismissCompletion)completion;

+ (void)showErrorWithText:(NSString*)text completion:(SVProgressHUDDismissCompletion)completion;

+ (void)dismissDelayWithCompletion:(SVProgressHUDDismissCompletion)completion;

+ (void)checkError:(YXError *)error;

+ (void)checkError:(YXError *)error completion:(SVProgressHUDDismissCompletion)completion;

@end

NS_ASSUME_NONNULL_END
