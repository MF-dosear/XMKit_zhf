//
//  XMUsersView.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/15.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXUsersBlock)(NSDictionary *user);

@interface XMUsersView : UITableView

@property (nonatomic, copy) YXUsersBlock block;

@end

NS_ASSUME_NONNULL_END
