//
//  YXColor.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#ifndef YXColor_h
#define YXColor_h

#import "JKCategories.h"

#define HEX_COLOR(string)      [UIColor jk_colorWithHexString:string]

#define MainColor HEX_COLOR(@"3A3B40")

#define BACKGROUND_COLOR      HEX_COLOR(@"efefef")

#define InfoColor     [UIColor infoBlueColor]
#define SuccessColor  [UIColor successColor]
#define WarnColor     [UIColor warningColor]
#define DangerColor   [UIColor dangerColor]
#define SkyBlueColor  [UIColor skyBlueColor]

#define ClearColor    [UIColor clearColor]
#define WhiteColor    [UIColor whiteColor]
#define RedColor      [UIColor redColor]
#define BlackColor    [UIColor blackColor]
#define OrangeColor   [UIColor orangeColor]
#define ProColor      [UIColor systemBlueColor]

#define BtnColor           HEX_COLOR(@"3A3B40")
#define BtnTitleColor      HEX_COLOR(@"F0F0F0")

/// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/// 获取随机颜色
#define RandColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define LINE_COLOR_A           HEX_COLOR(@"F0F0F0")
#define LINE_COLOR_B           HEX_COLOR(@"E6E6E6")
#define LINE_COLOR_C           HEX_COLOR(@"DCDCDC")

#define TEXT_COLOR_A           HEX_COLOR(@"C8C8C8")
#define TEXT_COLOR_B           HEX_COLOR(@"969696")
#define TEXT_COLOR_C           HEX_COLOR(@"667485")
#define TEXT_COLOR_D           HEX_COLOR(@"323232")
#define TEXT_COLOR             HEX_COLOR(@"F68F25")


#define BLACK_A                HEX_COLOR(@"666f73")
#define BLACK_B                HEX_COLOR(@"404040")
#define BLACK_C                HEX_COLOR(@"323232")

#define GRAY_A                 HEX_COLOR(@"e8e8e8")
#define GRAY_B                 HEX_COLOR(@"cccccc")
#define GRAY_C                 HEX_COLOR(@"b7b7b7")
#define GRAY_D                 HEX_COLOR(@"9a9a9a")

#define TEXTFIELDINPUT         HEX_COLOR(@"000000")
#define BUTTONINFO             HEX_COLOR(@"9a9a9a")

#endif /* YXColor_h */
