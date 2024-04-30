//
//  XMManager+Apple.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/18.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMManager+Apple.h"
#import "XMManager+BK.h"
#import "YXStatis.h"
#import "FMDBManager.h"
#import "YXNet+YX.h"

static NSString *_productId;
static SKProductsRequest *_request;
static NSArray *_products;
static NSMutableDictionary *_tran_info;

@implementation XMManager (Apple)

+ (void)createApplePsyDatabase{
    
    // 初始化数据库 创建数据库表
    [FMDBManager shared];
    
    // 苹果订单
    [FMDBManager createTable:TableAppleOrders fieldDict:@{
        TableLeak_user          : FMDB_TEXT,
        TableLeak_user_order_id : FMDB_TEXT,
        TableLeak_cost          : FMDB_TEXT,
        TableLeak_goodsName     : FMDB_TEXT,
        TableLeak_productId     : FMDB_TEXT
    }];
    
    // 苹果校验单（漏单）
    [FMDBManager createTable:TableReceipts fieldDict:@{
        TableLeak_user          : FMDB_TEXT,
        TableLeak_user_order_id : FMDB_TEXT,
        TableLeak_cost          : FMDB_TEXT,
        TableLeak_goodsName     : FMDB_TEXT,
        TableLeak_receipt_str   : FMDB_TEXT,
        TableLeak_tran_id       : FMDB_TEXT,
        TableLeak_check_count   : FMDB_TEXT
    }];
    
    // 苹果内部单
    [FMDBManager createTable:TableTrans fieldDict:@{
        TableLeak_tran_id       : FMDB_TEXT,
        TableLeak_tran_time     : FMDB_TEXT
    }];
    
    // 用户列表
    [FMDBManager createTable:TableUsers fieldDict:@{
        TableLeak_username  : FMDB_TEXT,
        TableLeak_pwd       : FMDB_TEXT
    }];
}

/// 添加苹果监听
+ (void)addTransactionObserver{
    XMManager *manager = [XMManager sharedXMManager];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
}

/// 发起内购请求
/// @param proId 商品id
+ (void)toPsyWithProductId:(NSString *)proId{
    
    if ([SKPaymentQueue canMakePayments] == false){
        
        [YXHUD showWarnWithText:LocalizedString(@"Purchase not open") completion:^{
            [XMManager sdkPsyBack:false];
        }];
        return;
    }
    
    // 支付队列
    [YXHUD show];
    
    _productId = proId;
    
    SKProduct *pro = nil;
    for (SKProduct *product in _products) {
        if ([product.productIdentifier isEqualToString:_productId]){
            pro = product;
            break;
        }
    }
    
    if (pro == nil) {
    
        NSArray * productArray = [[NSArray alloc] initWithObjects:proId,nil];
        NSSet *proSet = [NSSet setWithArray:productArray];
        
        // 发送获取商品列表请求
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:proSet];
        request.delegate = [XMManager sharedXMManager];
        [request start];
    }else{
        // 直接请求zhifu
        [XMManager toSKPay:pro];
    }
}

/// 开始支付
/// @param product product
+ (void)toSKPay:(SKProduct *)product{
    
    XMConfig *config = [XMConfig sharedXMConfig];
    XMInfos *info = [XMInfos sharedXMInfos];

    // 添加交易数据数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addValue:config.user_name           key:TableLeak_user];
    [dict addValue:config.orderID             key:TableLeak_user_order_id];
    [dict addValue:info.price                 key:TableLeak_cost];
    [dict addValue:info.goodsName             key:TableLeak_goodsName];
    [dict addValue:product.productIdentifier  key:TableLeak_productId];
    [FMDBManager insertData:TableAppleOrders fieldDict:dict];
    
    NSArray *list = [[SKPaymentQueue defaultQueue] transactions];
    BOOL isHave = false;
    for (SKPaymentTransaction *tran in list) {
        if (tran.transactionState == SKPaymentTransactionStatePurchased) {
            // 去校验
            [XMManager checkAppleOrder:tran];
        }
        
        // 结束
        if (tran.transactionState != SKPaymentTransactionStatePurchasing) {
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
        
        if ([tran.payment.productIdentifier isEqualToString:product.productIdentifier]) {
            isHave = true;
            break;
        }
    }
    
    if (isHave) {
        [YXHUD showInfoWithText:LocalizedString(@"Pay after 5s") completion:^{
            [YXHUD show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [YXHUD dismiss];
            });
        }];
    } else {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark -- SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    _products = response.products;
    
    if (_products.count <= 0) {
        [YXHUD showWarnWithText:LocalizedString(@"No product list") completion:^{
            [XMManager sdkPsyBack:false];
        }];
        return;
    }
    
    SKProduct *product = nil;
    for(SKProduct * pro in _products){
        if ([pro.productIdentifier isEqualToString:_productId]){
            product = pro;
            break;
        }
    }
    
    if (product == nil){
        [YXHUD showWarnWithText:LocalizedString(@"Not have the product") completion:^{
            [XMManager sdkPsyBack:false];
        }];
        return;
    }
    
    [XMManager toSKPay:product];
}

/// 支付请求结束
- (void)requestDidFinish:(SKRequest *)request{
    YXLog(@"支付请求结束");
}

/// 支付请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    [YXHUD showWarnWithText:LocalizedString(@"Purchase request failed") completion:^{
        [XMManager sdkPsyBack:false];
    }];
}

//交易结束
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    for (SKPaymentTransaction *tran in transactions) {
        
        if (tran.error) {
            YXLog(@"tran.error = %@",tran.error);
        }
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                //交易成功
                if ([tran.transactionIdentifier isValidString] && [tran.payment.productIdentifier isValidString]) {
                    
                    [queue finishTransaction:tran];
                    [XMManager checkAppleOrder:tran];
                }
            }break;
            case SKPaymentTransactionStateFailed:{
                //Apple Pay支付失败，请重试
                [queue finishTransaction:tran];
                [YXHUD showErrorWithText:LocalizedString(@"Purchase cancle or failed") completion:^{
                    [XMManager sdkPsyBack:false];
                    [XMManager deleteOrderWithTran:tran];
                }];
            }break;
            case SKPaymentTransactionStatePurchasing:{
                // 正在购买中...
                YXLog(@"正在购买中...");
            }break;
            case SKPaymentTransactionStateRestored:{
                // 已经购买过商品
                YXLog(@"已经购买过商品");
                [queue finishTransaction:tran];
            }
                break;
            default:{
                // 其他
                [queue finishTransaction:tran];
            }break;
        }
    }
}

/// 删除取消订单
+ (void)deleteOrderWithTran:(SKPaymentTransaction *)transaction{
    
    // 移除 取消订单
    NSString *productId = transaction.payment.productIdentifier;
    if ([productId isValidString]) {
        
        NSArray *product_keys = @[
            TableLeak_user          ,
            TableLeak_user_order_id ,
            TableLeak_cost          ,
            TableLeak_goodsName     ,
        ];
        
        NSArray *product_list = [FMDBManager selectedData:TableAppleOrders fieldKyes:product_keys key:TableLeak_productId value:productId];
        
        if (product_list.count > 0) {
            
            [FMDBManager deletedData:TableTrans key:TableLeak_productId value:productId];

        }
    }
}

/// 订单验证
+ (void)checkAppleOrder:(SKPaymentTransaction *)transaction{
    
    // 获取交易链接
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    if (url == nil){
        
        [YXHUD showErrorWithText:LocalizedString(@"Receipt acquisition failed") completion:^{
            [XMManager sdkPsyBack:false];
        }];
        return;
    }
    
    // 获取交易数据
    NSData *receiptData = [NSData dataWithContentsOfURL:url];
    if (receiptData == nil){
        
        [YXHUD showErrorWithText:LocalizedString(@"Receipt data get failed") completion:^{
            [XMManager sdkPsyBack:false];
        }];
        return;
    }
    
    NSString *tran_id = transaction.transactionIdentifier;
    NSArray *tran_keys = @[
        TableLeak_tran_id,
        TableLeak_tran_time
    ];
    NSArray *tran_list = [FMDBManager selectedData:TableTrans fieldKyes:tran_keys key:TableLeak_tran_id value:tran_id];
    if (tran_list.count > 0) {
        [YXHUD showInfoWithText:LocalizedString(@"Receipt repeat")];
        return;
    }
    
    NSString *productId = transaction.payment.productIdentifier;
    
    NSArray *product_keys = @[
        TableLeak_user          ,
        TableLeak_user_order_id ,
        TableLeak_cost          ,
        TableLeak_goodsName     ,
    ];
    
    NSArray *product_list = [FMDBManager selectedData:TableAppleOrders fieldKyes:product_keys key:TableLeak_productId value:productId];
    
    if (product_list.count > 0) {
        
        NSDictionary *dict = product_list.lastObject;
        
        NSString *user        = dict[TableLeak_user];
        NSString *order_id    = dict[TableLeak_user_order_id];
        NSString *cost        = dict[TableLeak_cost];
        NSString *goodName    = dict[TableLeak_goodsName];
        
        [XMManager verifyPayWithOrderID:order_id receipt:receiptData user:user cost:cost goodsName:goodName transaction:transaction];

    } else {
        [YXHUD showErrorWithText:LocalizedString(@"Order info lost") completion:^{
            // 回调
            [XMManager sdkPsyBack:false];
        }];
    }
}

// 提交到后台验证
+ (void)verifyPayWithOrderID:(NSString *)orderID receipt:(NSData *)receipt user:(NSString *)user cost:(NSString *)cost goodsName:(NSString *)goodsName transaction:(SKPaymentTransaction *)transaction{
    
    // 存储校验单
    NSString *tran_id = transaction.transactionIdentifier;
    NSArray *tran_keys = @[TableLeak_tran_id];
    NSArray *tran_list = [FMDBManager selectedData:TableReceipts fieldKyes:tran_keys key:TableLeak_tran_id value:tran_id];
    
    [YXStatis paymentEvent:cost];
    
    if (tran_list.count == 0) {
        NSString *receiptStr = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict addValue:user       key:TableLeak_user];
        [dict addValue:orderID    key:TableLeak_user_order_id];
        [dict addValue:cost       key:TableLeak_cost];
        [dict addValue:goodsName  key:TableLeak_goodsName];
        [dict addValue:receiptStr key:TableLeak_receipt_str];
        [dict addValue:tran_id    key:TableLeak_tran_id];
        [dict addValue:@"0"       key:TableLeak_check_count];
        
        // 存校验信息
        BOOL isSave = [FMDBManager insertData:TableReceipts fieldDict:dict];
        if (isSave) {
            // 移除苹果订单
            [FMDBManager deletedData:TableAppleOrders key:TableLeak_user_order_id value:orderID];
        }
        
        // 存支付队列
        NSString *data_time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        NSMutableDictionary *tran_dict = [NSMutableDictionary dictionary];
        [tran_dict addValue:tran_id    key:TableLeak_tran_id];
        [tran_dict addValue:data_time  key:TableLeak_tran_time];
        [FMDBManager insertData:TableTrans fieldDict:tran_dict];
    }
    
    [YXNet applePsyWithOrderID:orderID receipt:receipt user:user cost:cost tran_id:tran_id isHUD:true result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {

        if (isSuccess) {
            
            // 移除校验单(漏单)
            [FMDBManager deletedData:TableReceipts key:TableLeak_user_order_id value:orderID];
            // 支付成功回调
            [XMManager sdkPsyBack:true];
            // 上报支付结果
            [YXStatis playerDataWithType:YXStatisTypeAFEventPurchase price:cost];
            // 购买成功
            [YXHUD showSuccessWithText:LocalizedString(@"Purchase successful")];
            
        } else {
            
            NSString *msg = LocalizedString(@"Order verification failed detail");
            [UIAlertController alertTitle:LocalizedString(@"Order verification failed") msg:msg handler:^(UIAlertAction * _Nonnull action) {
                [XMManager sdkPsyBack:false];
//                [XMManager copyWithText:orderID msg:@"订单号"];
            }];
            
//            [YXHUD showWarnWithText:@"订单校验失败" completion:^{
//                [XMManager sdkPsyBack:false];
//            }];
        }
    }];
}

+ (void)copyWithText:(NSString *)text msg:(NSString *)msg{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
    if (pasteboard == nil) {
        [YXHUD showErrorWithText:[NSString stringWithFormat:@"%@%@",msg,LocalizedString(@"Copy failed")]];
    } else {
        [YXHUD showSuccessWithText:[NSString stringWithFormat:@"%@%@",msg,LocalizedString(@"Copy successful")]];
    }
}

/// 校验漏单
+ (void)checkReceipts{
    
    NSArray *receipt_keys = @[
        TableLeak_user          ,
        TableLeak_user_order_id ,
        TableLeak_cost          ,
        TableLeak_goodsName     ,
        TableLeak_receipt_str   ,
        TableLeak_tran_id       ,
        TableLeak_check_count
    ];
    
    NSArray *receipt_list = [FMDBManager selectedData:TableReceipts fieldKyes:receipt_keys];
    
    NSInteger count = receipt_list.count;
    for (int i = 0; i < count; i++) {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSDictionary *dict = receipt_list[i];
            
            NSString *order_id    = dict[TableLeak_user_order_id];
            NSInteger count       = [dict[TableLeak_check_count] integerValue] + 1;
            
            if (count > 10) {
                // 删除
                [FMDBManager deletedData:TableReceipts key:TableLeak_user_order_id value:order_id];
                
            } else {
                
                // 更新
                NSMutableDictionary *mDict = [dict mutableCopy];
                [mDict addValue:[NSString stringWithFormat:@"%ld",count] key:TableLeak_check_count];
                [FMDBManager updateData:TableReceipts filedDict:mDict key:TableLeak_user_order_id value:order_id];
                
                // 校验
                NSString *user        = dict[TableLeak_user];
                NSString *cost        = dict[TableLeak_cost];
                NSString *goodName    = dict[TableLeak_goodsName];
                NSString *receipt_str = dict[TableLeak_receipt_str];
                NSString *tran_id     = dict[TableLeak_tran_id];
                
                NSData *receipt_data = [[NSData alloc] initWithBase64EncodedString:receipt_str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                [XMManager verifyFailPayWithOrderID:order_id receipt:receipt_data user:user cost:cost goodsName:goodName tran_id:tran_id ];
            }
        });
    }
}

/// 失败订单校验
+ (void)verifyFailPayWithOrderID:(NSString *)orderID receipt:(NSData *)receipt user:(NSString *)user cost:(NSString *)cost goodsName:(NSString *)goodsName tran_id:(NSString *)tran_id{
    
    [XMInfos sharedXMInfos].price = cost;
    
    [YXNet applePsyWithOrderID:orderID receipt:receipt user:user cost:cost tran_id:tran_id isHUD:false result:^(BOOL isSuccess, id  _Nullable data, YXError * _Nullable error) {

        if (isSuccess) {
        
            // 移除校验单(漏单)
            [FMDBManager deletedData:TableReceipts key:TableLeak_user_order_id value:orderID];
            // 上报支付结果
            [YXStatis playerDataWithType:YXStatisTypeAFEventPurchase price:cost];
            // 提示
            [YXHUD showSuccessWithText:LocalizedString(@"Pay successful")];
        } else {
            
        }
    }];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    for (SKPaymentTransaction *tran in transactions) {

        NSString *tran_id = tran.transactionIdentifier;
        if ([tran_id isValidString]) {
            
            NSArray *tran_keys = @[
                TableLeak_tran_id,
                TableLeak_tran_time
            ];
            NSArray *tran_list = [FMDBManager selectedData:TableTrans fieldKyes:tran_keys key:TableLeak_tran_id value:tran_id];

            if (tran_list.count > 0) {
                // 移除支付队列
                [FMDBManager deletedData:TableTrans key:TableLeak_tran_id value:tran_id];
            }
        } else {
            YXLog(@"tran_id 为空!");
        }
    }
}

@end
