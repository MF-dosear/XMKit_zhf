//
//  XMUsersCell.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/15.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const YXUsersCellID = @"XMUsersCell";

typedef void(^YXUsersCellBlock)(NSInteger tag);

@interface XMUsersCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, copy) YXUsersCellBlock block;

@end

NS_ASSUME_NONNULL_END
