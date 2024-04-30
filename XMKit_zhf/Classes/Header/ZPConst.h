//
//  YXConst.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#ifndef YXConst_h
#define YXConst_h

// 通知
static NSString *const NOTI_RESET_FRAME  = @"NOTI_RESET_FRAME";

// 缓存 cache
static NSString *const BindRemindPrefix  = @"BindRemindPrefix";

// channel
static NSString *const GMChannel  = @"111111";

// 游戏语言
static NSString *const XMGAMELanguageCache  = @"XMGAMELanguageCache";

// 自动登录cache
static NSString *const YXAutoLoginCache  = @"YXAutoLoginCache";

// 心跳参数
static NSString *const YXHeadCache  = @"YXHeadCache";

/// 背景 左右间距
static CGFloat const BKLEFTSPACE = 16;

/// 背景 高度
static CGFloat const BKHEIGHT = 340;

/// Title高度
static CGFloat const TITLEHEIGHT = 45;

/// TextField左右间距
static CGFloat const TEXTLEFTSPACE = 28;

/// TextField高度
static CGFloat const TEXTHEIGHT = 45;

/// 主按钮左右间距
static CGFloat const MAINBTNLEFTSPACE = 28;

/// 主按钮高度
static CGFloat const MAINBTNHEIGHT = 42;

/// 普通按钮高度
static CGFloat const DEINBTNHEIGHT = 35;

/// 普通图片宽高
static CGFloat const DEIMGHEIGHT = 25;

/// 红点直径
static const CGFloat RedRadius = 8;


/// 苹果订单
static NSString * const TableAppleOrders          = @"TableAppleOrders";  // 苹果订单

static NSString * const TableLeak_productId       = @"productId";         // 商品id
static NSString * const TableLeak_user            = @"user";              // 用户
static NSString * const TableLeak_user_order_id   = @"user_order_id";     // 单号
static NSString * const TableLeak_cost            = @"cost";              // 价格
static NSString * const TableLeak_goodsName       = @"goodsName";         // 商品名称

/// 苹果校验单（漏单）
static NSString * const TableReceipts             = @"TableReceipts";     // 苹果校验单（漏单）

static NSString * const TableLeak_receipt_str    = @"receipt_str";        // 校验参数
static NSString * const TableLeak_tran_id        = @"tran_id";            // 苹果订单id
static NSString * const TableLeak_check_count    = @"check_count";        // 校验次数

/// 苹果内部单
static NSString * const TableTrans               = @"TableTrans";         // 苹果内部单
static NSString * const TableLeak_tran_time      = @"tran_time";          // 创建时间

static NSString * const TableUsers               = @"TableUsers";         // 用户列表
static NSString * const TableLeak_username       = @"username";           // 用户名
static NSString * const TableLeak_pwd            = @"pwd";                // pwd

#endif /* YXConst_h */
