//
//  XMManager+Share.h
//  XMSDK
//
//  Created by dosear on 2021/8/6.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import <XMKit_zhf/XMSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMManager (Share)<FBSDKSharingDelegate>

/// 分享链接
/// @param url 链接
/// @param quote 文本
+ (void)sdkShareUrl:(NSString *)url quote:(NSString *)quote;

/// 分享图片
/// @param image 图片
+ (void)sdkShareImage:(UIImage *)image;

/// 分享视频
/// @param videoData videoData 视频资源
+ (void)sdkShareVideoData:(id)videoData;

@end

NS_ASSUME_NONNULL_END
