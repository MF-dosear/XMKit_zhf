//
//  XMEmailVC.h
//  XMSDK
//
//  Created by dosear on 2021/7/30.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OVEmailBlock)(void);

@interface XMEmailVC : XMBindBaseVC

@property (nonatomic, copy) OVEmailBlock block;

@end

NS_ASSUME_NONNULL_END
