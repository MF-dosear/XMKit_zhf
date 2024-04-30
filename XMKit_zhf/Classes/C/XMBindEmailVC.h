//
//  OVBindVC.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OVBindEmailBlock)(void);

@interface XMBindEmailVC : XMBaseVC

@property (nonatomic, copy) OVBindEmailBlock block;

@end

NS_ASSUME_NONNULL_END
