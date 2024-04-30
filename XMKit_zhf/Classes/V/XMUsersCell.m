//
//  XMUsersCell.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/15.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMUsersCell.h"

@implementation XMUsersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imgView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_account")];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.height.mas_equalTo(24);
        make.centerY.mas_equalTo(self.imgView.superview.mas_centerY);
    }];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [IMAGE(@"sdk_close") jk_imageScaledToFitSize:CGSizeMake(DEIMGHEIGHT, DEIMGHEIGHT)];
    [self.btn setImage:image forState:0];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(TEXTHEIGHT);
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.font = FONTNAME(14);
    self.label.textColor = TEXT_COLOR_C;
    [self.contentView addSubview:self.label];
    CGFloat left = 6;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right).offset(left);
        make.right.mas_equalTo(self.btn.mas_left).offset(-left);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)btnAction:(UIButton *)btn{
    if (self.block) {
        self.block(btn.tag);
    }
}

@end
