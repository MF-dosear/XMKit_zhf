//
//  XMManager+Share.m
//  XMSDK
//
//  Created by dosear on 2021/8/6.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMManager+Share.h"

@implementation XMManager (Share)

#pragma mark - 分享

/// 系统分享
/// - Parameters:
///   - image: 图片
///   - url: 链接
///   - title: 标题
+ (void)sdkShareImage:(UIImage *)image url:(NSString *)url title:(NSString *)title{
    NSMutableArray *mArr = [NSMutableArray array];
    if (image != nil){
        [mArr addObject:image];
    }
    NSURL *k_url = [NSURL URLWithString:url];
    if (k_url != nil){
        [mArr addObject:k_url];
    }
    if (title.length > 0){
        [mArr addObject:title];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:mArr applicationActivities:nil];
    
    UIViewController *cu_vc = [XMCommon currentVC];
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]){
        UIView *sourceView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
        CGRect frame = sourceView.frame;
        frame.size.height = frame.size.height / 4.0;
        frame.origin.x = 0;
        frame.origin.y = 0;
        activityVC.popoverPresentationController.sourceView = sourceView;
        activityVC.popoverPresentationController.sourceRect = frame;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    } else {
        activityVC.popoverPresentationController.sourceView = cu_vc.view;
        activityVC.popoverPresentationController.sourceRect = cu_vc.view.bounds;
    }
    
    [cu_vc presentViewController:activityVC animated:true completion:nil];
    //分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
    };
}

// 分享链接
+ (void)sdkShareUrl:(NSString *)url quote:(NSString *)quote{
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:url];
    
    content.quote = quote;
    
    [XMManager shareWithContent:content];
}

+ (void)sdkShareImage:(UIImage *)image{
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] initWithImage:image isUserGenerated:true];
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [XMManager shareWithContent:content];
}

+ (void)sdkShareVideoData:(id)videoData{
    
    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] initWithVideoAsset:videoData previewPhoto:nil];
    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.video = video;
    
    [XMManager shareWithContent:content];
}

+ (void)shareWithContent:(id)content{
    
    XMManager *manager = [XMManager sharedXMManager];
    
    UIViewController *vc = [XMCommon currentVC];
    [FBSDKShareDialog showFromViewController:vc withContent:content delegate:manager];
}

#pragma mark --FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary<NSString *, id> *)results{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}

@end
