//
//  XMBindBtn.m
//  XMSDK
//
//  Created by dosear on 2021/7/30.
//  Copyright © 2021 YXQ. All rights reserved.
//

#import "XMBindBtn.h"

@interface XMBindBtn ()

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation XMBindBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:WhiteColor forState:0];
        [self setTitleColor:GRAY_A forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        
    }
    return self;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = LocalizedString(@"Linked");
        _rightLabel.textColor = TEXT_COLOR_A;
        _rightLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected == true) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.rightLabel.hidden = false;
//        [self setBackgroundColor:[UIColor jk_colorWithHexString:@"EFEFEF"]];
//        self.layer.borderColor = [UIColor jk_colorWithHexString:@"EFEFEF"].CGColor;
//        self.layer.borderWidth = 0;
        self.userInteractionEnabled = false;
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 26, 0, -26);
        
        [self setBackgroundColor:LINE_COLOR_B];
        
    } else{
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.rightLabel.hidden = true;
//        [self setBackgroundColor:[UIColor whiteColor]];
//        self.layer.borderColor = [UIColor jk_colorWithHexString:@"CCCCCC"].CGColor;
//        self.layer.borderWidth = 1;
        
        self.userInteractionEnabled = true;
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        
        
        if (self.tag == 10001) {
            // 苹果
            [self setBackgroundColor:WhiteColor];
        } else if (self.tag == 10002) {
            // fb
            [self setBackgroundColor:HEX_COLOR(@"0061b2")];
        } else if (self.tag == 10003) {
            // 邮箱
            [self setBackgroundColor:HEX_COLOR(@"7cba59")];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 5;
}

@end
