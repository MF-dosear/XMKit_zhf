//
//  YXNet+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "YXNet+YX.h"

#import "YXNetApi.h"
#import <XMKit_zhf/XMInfos.h>
#import <WebKit/WebKit.h>
#import "UIDevice+YX.h"

static NSString *const AES128_KEY = @"UEUJJWQQKLAOILQN";
static NSString *const AES128_VI  = @"618336901";

@implementation YXNet (YX)

/**
 GET 请求
 @param url api地址
 @param params 请求参数
 @param result 返回结果
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result{
    [YXNet requestMode:YXNetModeGET url:url params:params result:result];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result{
    [YXNet requestMode:YXNetModePOST url:url params:params result:result];
}

+ (void)hudGetWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result{
    [YXHUD show];
    [YXNet requestMode:YXNetModeGET url:url params:params result:^(BOOL isSuccess, id data, YXError *error) {
        [YXHUD dismiss];
        result(isSuccess,data,error);
    }];
}

+ (void)hudPostWithURL:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result{
    [YXHUD show];
    [YXNet requestMode:YXNetModePOST url:url params:params result:^(BOOL isSuccess, id data, YXError *error) {
        [YXHUD dismiss];
        result(isSuccess,data,error);
    }];
}

+ (void)requestMode:(YXNetMode)mode url:(NSString *)url params:(NSDictionary *)params result:(ResultBlock)result{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([url isEqualToString:YXSDKApple]) {
        [mDict removeObjectForKey:@"receipt_data"];
    }
    
    XMInfos  *infos  = [XMInfos sharedXMInfos];
    NSString *sign = [YXNet signWithUrl:url appid:infos.AppID appkey:infos.AppKey info:mDict];
    
    NSString *data_str = [YXNet formatParams:mDict];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    [info addValue:url         key:@"service"];
    [info addValue:infos.AppID key:@"appid"];
    [info addValue:data_str    key:@"data"];
    
    [info addValue:sign        key:@"sign"];
    [info addValue:@"iOS"      key:@"platform"];
    [info addValue:GMChannel   key:@"channel"];
    
    [info addValue:DEV_IDFA    key:@"idfa"];
    [info addValue:DEV_IDFA    key:@"udid"];
    
    if ([url isEqualToString:YXSDKApple]) {
        NSString *receipt = params[@"receipt_data"];
        [info addValue:receipt         key:@"receipt_data"];
        [info addValue:params[@"cost"] key:@"cost"];
    }
    
    // 1.创建url
    NSString *api;
    
    
#if YXDebug
// 处于开发阶段

    api = YXNetAPI_Test;

#else
// 处于发布阶段

    api = YXNetAPI_Formal;

#endif
    
    api = [api stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *apiUrl = [NSURL URLWithString:api];
    
    // 2.创建request
    NSInteger timeout = 30;
    if ([url isEqualToString:YXSDKInit]) {
        // 初始化超时时间10秒
        timeout = 10;
    }
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:apiUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    request.HTTPMethod = mode == YXNetModeGET ? @"GET" : @"POST";
    request.HTTPBody = [[NSString bodyWithInfo:info] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSBundle serverLanguage] forHTTPHeaderField:@"Language"];
    
    NSURLSessionConfiguration *cf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableDictionary *cf_hd = [NSMutableDictionary dictionary];
    cf.HTTPAdditionalHeaders = cf_hd;
    
    // 3.采用苹果提供的共享session
    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:cf];
    
    // 4.由系统直接返回一个dataTask任务
    // 网络请求完成之后completionHandler就会执行，NSURLSession自动实现多线程
    NSURLSessionDataTask * dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 主线程返回
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                YXError *err = [YXError initWithCode:@"100600"];
                err.describe = LocalizedString(@"Net error,timeout");
                result(false,nil,err);
            } else{
                [YXNet getResult:data url:url result:result];
            }
        });
    }];
    
    // 5.每一个任务默认都是挂起的，需n要调用 resume 方法
    [dataTask resume];
}

+ (NSString *)formatParams:(NSDictionary *)params{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        YXLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *strM = [NSMutableString stringWithString:jsonString];
    NSRange range = {0, jsonString.length};
    //去掉字符串中的空格
    [strM replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0, strM.length};
    //去掉字符串中的换行符
    [strM replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return strM;
}

+ (void)getResult:(NSData *)responseObject url:(NSString *)url result:(ResultBlock)result{
    
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
    
    YXError *err = [[YXError alloc] init];
    if (error) {
        err.code = @"100600";
        err.describe = LocalizedString(@"Data parsing error");
        result(false,nil,err);
        return;
    }
    
    YXLog(@"result = %@",[dict jk_JSONString]);
    
    if ([url isEqualToString:YXSDKApple]) {
        
        // 实名认证解析
        NSDictionary *state = dict[@"state"];
        if (state == nil) {
            err.code = @"100600";
            err.describe = LocalizedString(@"Data parsing error");
            result(false,nil,err);
            return;
        }
        
        NSString *codes = [NSString stringWithFormat:@"%@",state[@"code"]];
        NSInteger code = [codes integerValue];
        NSString *message = [NSString stringWithFormat:@"%@",state[@"msg"]];
        id data = dict[@"data"];
        if (code == 1) {
            result(true,data,nil);
        } else {
            err.code = codes;
            err.describe = message;
            result(false,data,err);
        }
        return;
    }
    
    NSDictionary *state = dict[@"state"];
    if (state == nil) {
        err.code = @"100600";
        err.describe = LocalizedString(@"Data parsing error");
        result(false,nil,err);
        return;
    } 
    
    NSInteger code = [state[@"code"] integerValue];
    NSString *message = [NSString stringWithFormat:@"%@",state[@"msg"]];
    id data = dict[@"data"];
    if (code == 1) {
        err.code = [NSString stringWithFormat:@"%ld",(long)code];
        err.describe = message;
        result(true,data,err);
    } else {
        err.code = [NSString stringWithFormat:@"%ld",(long)code];;
        err.describe = message;
        result(false,data,err);
    }
}

#pragma mark - 私有方法
// 将NSDictionary中的Null类型的项目转化成@""
+ (NSDictionary *)nullDic:(NSDictionary *)myDic{
    
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < keyArr.count; i ++){
        
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [YXNet changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

// 将NSDictionary中的Null类型的项目转化成@""
+ (NSArray *)nullArr:(NSArray *)myArr{
    
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++){
        id obj = myArr[i];
        obj = [YXNet changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

// 将NSString类型的原路返回
+ (NSString *)stringToString:(NSString *)string{
    return string;
}

// 将Null类型的项目转化成@""
+ (NSString *)nullToString{
    return @"";
}

#pragma mark - 公有方法
// 类型识别:将所有的NSNull类型转化成@""
+ (id)changeType:(id)myObj{
    
    if ([myObj isKindOfClass:[NSDictionary class]]){
        
        return [YXNet nullDic:myObj];
    }else if([myObj isKindOfClass:[NSArray class]]){
        
        return [YXNet nullArr:myObj];
    }else if([myObj isKindOfClass:[NSString class]]){
        
        return [YXNet stringToString:myObj];
    }else if([myObj isKindOfClass:[NSNull class]]){
        
        return [YXNet nullToString];
    }else{
        
        return myObj;
    }
}

// sign
+ (NSString *)signWithUrl:(NSString *)url appid:(NSString *)appid appkey:(NSString *)appkey info:(NSDictionary *)info{
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:10];
    [str appendFormat:@"%@%@",appid,url];
    
    //
    NSArray * arr = [info allKeys];
    //排序
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray * result = [arr sortedArrayUsingComparator:sort];
    NSString * split = @"";
    //
    for (int i = 0; i < result.count; i++) {
        [str appendFormat:@"%@%@=%@",split,result[i],[info objectForKey:result[i]]];
        split =@"&";
    }
    //
    [str appendFormat:@"%@",appkey];
    NSString *text = [str encodeUrl];
    text = [text jk_md5String];
    return text;
}

///// 苹果支付校验
//+ (void)apple2PsyWithOrderID:(NSString *)orderID receipt:(NSData *)receipt user:(NSString *)user cost:(NSString *)cost tran_id:(NSString *)tran_id result:(ResultBlock)result{
//    
//    NSMutableDictionary *info  = [NSMutableDictionary dictionary];
//    [info addValue:orderID   key:@"orderid"];
//    [info addValue:user      key:@"username"];
//    [info addValue:receipt   key:@"receipt_data"];
//    [info addValue:tran_id   key:@"transaction_id"];
//    
//    [YXNet applePayWithParams:info price:cost context:YXSDKApple result:result];
//}

//+ (void)applePayWithParams:(NSMutableDictionary *)params price:(NSString *)price context:(NSString *)context result:(ResultBlock)result{
//
//    //苹果支付接口时特殊处理 将 receiptData字段 放在parameters字典中，而不是data中
//    NSString *receiptStr = [params[@"receipt_data"] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    [params removeObjectForKey:@"receipt_data"];
//
//    XMInfos  *infos  = [XMInfos sharedXMInfos];
//    NSString *sign = [YXNet creatSign:context appid:infos.AppID appkey:infos.AppKey data:params];
//
//    NSString *data_str = [params jk_JSONString];
//
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters addValue:context           key:@"service"];
//    [parameters addValue:infos.AppID       key:@"appid"];
//    [parameters addValue:sign              key:@"sign"];
//    [parameters addValue:data_str          key:@"data"];
//
//    [parameters addValue:@"iOS"            key:@"platform"];
//    [parameters addValue:@"111111"         key:@"channel"];
//    [parameters addValue:DEV_IDFA          key:@"idfa"];
//    [parameters addValue:DEV_IDFA          key:@"udid"];
//    [parameters addValue:[UIDevice model]  key:@"ptmodel"];
//
//    parameters[@"receipt_data"] = receiptStr;
//    parameters[@"cost"] = price;
//
//    // 1.创建url
//    // 请求一个网页
//    NSString *urlString = @"http://blzjapple.xmwan.com";
//
//    // 一些特殊字符编码
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    //创建request
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
//     request.HTTPMethod = @"POST";
//    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    NSString *jsonStr = @"";
//
//    NSArray *arrKeys = [parameters allKeys];
//    for (int i = 0 ; i < arrKeys.count ; i++)
//    {
//        NSString *key = arrKeys[i];
//        NSString *value = [parameters valueForKey:key];
//
//
//
//        if (i+1 == arrKeys.count) {
//            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[self encodeURIComponent:value]]];
//        }else{
//            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[self encodeURIComponent:value]]];
//        }
//    }
////    NSLog(@"第二个字典%@",jsonStr);
//    request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSURLSessionConfiguration *cf = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    // 3.采用苹果提供的共享session
//    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:cf];
//
//    // 4.由系统直接返回一个dataTask任务
//    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        // 主线程返回
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if (error) {
//                YXError *err = [YXError initWithCode:@"100600"];
//                err.describe = LocalizedString(@"Net error,timeout");
//                result(false,nil,err);
//            } else{
//                [YXNet getResult:data url:YXSDKApple result:result];
//            }
//        });
//    }];
//
//    // 5.每一个任务默认都是挂起的，需要调用 resume 方法
//    [dataTask resume];
//}

#pragma mark 创建sign
+(NSString*)creatSign:(NSString*)service appid:(NSString*)appid appkey:(NSString*)appkey data:(NSDictionary*)data{
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:10];
    [str appendFormat:@"%@%@",appid,service];
    //
    NSArray *arr = [data allKeys];
    //排序
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;

    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *result = [arr sortedArrayUsingComparator:sort];
    NSString *split = @"";
    //
    for (int i = 0; i < result.count; i++) {
        [str appendFormat:@"%@%@=%@",split,result[i],[data objectForKey:result[i]]];
        split =@"&";
    }
    //
    [str appendFormat:@"%@",appkey];
    // DLOG(@"没有MD5加密的数据:%@",str);
    return ([[str encodeUrl] jk_md5String]);
}

//特殊字符处理
+(NSString*)encodeURIComponent:(NSString*)str{

    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

+ (void)uploadBugInfo:(NSString *)bug result:(ResultBlock)result{
    
    // 1、开始请求数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2、设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    AFHTTPRequestSerializer *requset = [AFHTTPRequestSerializer serializer];
    requset.stringEncoding = NSUTF8StringEncoding;
    requset.timeoutInterval = 30;
    manager.requestSerializer = requset;
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", @"text/javascript", nil];
    manager.responseSerializer = response;
    
    NSString *url = @"http://www.bugly.fun/api/common/uploadBugInfo";
    
    NSString *la = [NSBundle serverLanguage];
    
    XMInfos *info = [XMInfos sharedXMInfos];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:la key:@"language"];
    [params addValue:DEV_SYSTEM_VERSION key:@"systemVersion"];
    [params addValue:DEV_ALIAS key:@"alias"];
    
    [params addValue:DEV_NAME  key:@"systemName"];
    [params addValue:DEV_MODEL key:@"model"];
    [params addValue:DEV_LOCALIZE_MODEL key:@"localizedModel"];
    
    [params addValue:APPNAME      key:@"appname"];
    [params addValue:APPVERSION   key:@"version"];
    [params addValue:info.AppleID key:@"appleid"];
    
    [params addValue:DEV_MODELNAME key:@"modelName"];
    [params addValue:DEV_BRAND     key:@"brand"];
    [params addValue:bug           key:@"bugInfo"];
    
    
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [responseObject[@"code"] intValue];
        if (code == 0) {
            NSDictionary *info = responseObject[@"data"];
            result(true,info,nil);
        } else {
            YXError *err = [YXError initWithCode:@"100600"];
            err.describe = responseObject[@"msg"];
            result(false,nil,err);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YXError *err = [YXError initWithCode:@"100600"];
        err.describe = LocalizedString(@"Net error,timeout");
        result(false,nil,err);
    }];
}

+ (void)hotfixListWithAppleID:(NSString *)appleID result:(ResultBlock)result{

    // 1、开始请求数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2、设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    AFHTTPRequestSerializer *requset = [AFHTTPRequestSerializer serializer];
    requset.stringEncoding = NSUTF8StringEncoding;
    requset.timeoutInterval = 30;
    manager.requestSerializer = requset;
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", @"text/javascript", nil];
    manager.responseSerializer = response;
    
    NSString *url = [NSString stringWithFormat:@"%@/api/gameh5data.php",YXNetAPI_Wap];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addValue:appleID  key:@"appid"];
    [params addValue:APPVERSION    key:@"version"];
    [params addValue:@"hotFixcry2" key:@"act"];
    
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            id obj = [YXNet AES128DecodeData:responseObject[@"data"]];
            result(true,obj,nil);
        } else {
            YXError *err = [YXError initWithCode:[NSString stringWithFormat:@"%ld",code]];
            err.describe = responseObject[@"msg"];
            result(false,nil,err);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YXError *err = [YXError initWithCode:@"100600"];
        err.describe = LocalizedString(@"Net error,timeout");
        result(false,nil,err);
    }];
}

+ (id)AES128DecodeData:(NSString *)str{
    if (str.length == 0) {
        return nil;
    }
    
    NSData *iv_data = [AES128_VI dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *value_AES_data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];;
    
    NSData *value_data = [YXNet AES128:value_AES_data algorithm:kCCAlgorithmAES128 key:AES128_KEY iv:iv_data];
    
    if (value_data == nil) {
        return nil;
    }
    
    NSString *json_str = [value_data jk_UTF8String];
    // 去掉首尾的空白字符
    json_str = [json_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 去除掉控制字符
    json_str = [json_str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    NSData *json_data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:json_data options:0 error:&error];
    
    if (error) {
        YXLog(@"AES128DecodeData = %@",error.description);
        return nil;
    }
    
    return result;
}

+ (NSData *)AES128:(NSData *)data algorithm:(CCAlgorithm)algorithm key:(NSString *)key iv:(NSData *)iv {
    
    NSMutableData *keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    size_t dataMoved;
    
    int size = 0;
    if (algorithm == kCCAlgorithmAES128 ||algorithm == kCCAlgorithmAES) {
        size = kCCBlockSizeAES128;
    }else if (algorithm == kCCAlgorithmDES) {
        size = kCCBlockSizeDES;
    }else if (algorithm == kCCAlgorithm3DES) {
        size = kCCBlockSize3DES;
    }if (algorithm == kCCAlgorithmCAST) {
        size = kCCBlockSizeCAST;
    }
    
    NSMutableData *decryptedData = [NSMutableData dataWithLength:data.length + size];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,                    // kCCEncrypt or kCCDecrypt
                                     algorithm,
                                     kCCOptionECBMode,                        // Padding option for CBC Mode
                                     keyData.bytes,
                                     keyData.length,
                                     iv.bytes,
                                     data.bytes,
                                     data.length,
                                     decryptedData.mutableBytes,    // encrypted data out
                                     decryptedData.length,
                                     &dataMoved);                   // total data moved
    
    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }
    return nil;
}

+ (void)uploadEvent:(NSString *)event play_session:(NSString *)play_session properties:(NSString *)properties{
    
//    XMConfig *config = [XMConfig sharedXMConfig];
//    XMInfos *infos = [XMInfos sharedXMInfos];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params addValue:config.uid     key:@"#account_id"];
//    [params addValue:infos.AppID    key:@"#appid"];
//    [params addValue:event          key:@"#event_name"];
//    
//    [params addValue:@""      key:@"#ip"];
//    [params addValue:@"track" key:@"#type"];
//    
//    if (play_session.length > 0){
//        [params addValue:play_session key:@"#play_session"];
//    }
//    
//    if (properties.length > 0){
//        NSData *data = [properties dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        [params addValue:dict key:@"properties"];
//    }
//    
//    NSDate *date = [NSDate date];
//    NSTimeInterval timeInterval = [date timeIntervalSince1970];
//    NSString *uuid = [NSString stringWithFormat:@"%.0f%@",timeInterval,[NSString randomWithLength:8]];
//    [params addValue:uuid key:@"#uuid"];
//    
//    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
//    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    dateFmt.locale =  [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages]  objectAtIndex:0]];
//    NSString *time = [dateFmt stringFromDate:date];
//    [params addValue:time key:@"#time"];
//    
//    NSMutableDictionary *device = [NSMutableDictionary dictionary];
//    [device addValue:DEV_IDFV key:@"#device_id"];
//    [device addValue:DEV_IDFA key:@"#idfa"];
//    
//    [device addValue:DEV_MODELNAME key:@"#device_model"];
//    [device addValue:APPVERSION    key:@"#app_version"];
//    [device addValue:@"0.2.2"      key:@"#lib_version"];
//    
//    NSString *system = [UIDevice currentDevice].systemVersion;
//    [device addValue:system        key:@"#os_version"];
//    [device addValue:DEV_MODELNAME key:@"#manufacturer"];
//    [device addValue:@"iOS"        key:@"#os"];
//    [device addValue:APPBundleID   key:@"#bundle_id"];
//    
////    NSString *deviceJson = [device jk_JSONString];
//    [params addValue:device key:@"#device"];
//    
//    NSURL *url = [NSURL URLWithString:YXNetAPI_Event];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
//    
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
//    conf.HTTPAdditionalHeaders = @{@"Content-Type":@"application/json"};
//    
//    // 3.采用苹果提供的共享session
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        if (error == nil) {
//            NSLog(@"%@事件上报成功",event);
//        } else {
//            NSLog(@"%@事件上报失败",event);
//        }
//    }];
//    
//    [dataTask resume];
}

/// 事件上报
/// - Parameter mode
+ (void)uploadEventMode:(EventMode)mode{
    
    NSString *event;
    switch (mode) {
        case EventMode_active_start: event = @"sdk_active_start";
            break;
        case EventMode_active_success: event = @"sdk_active_success";
            break;
        case EventMode_register_success: event = @"sdk_register_success";
            break;
        case EventMode_login_success: event = @"sdk_login_success";
            break;
        case EventMode_accountlogin_show: event = @"sdk_accountlogin_show";
            break;
        case EventMode_phonereg_show: event = @"sdk_phonereg_show";
            break;
        case EventMode_phonelogin_show: event = @"sdk_phonelogin_show";
            break;
        case EventMode_quickreg_show: event = @"sdk_quickreg_show";
            break;
        case EventMode_geelogin_show: event = @"sdk_geelogin_show";
            break;
        case EventMode_realname_show: event = @"sdk_realname_show";
            break;
        case EventMode_realname_commit: event = @"sdk_realname_commit";
            break;
        case EventMode_realname_success: event = @"sdk_realname_success";
            break;
        default: event = @"";
            break;
    }
    [YXNet uploadEvent:event play_session:@"" properties:@""];
}

+ (void)head{

    NSString *play_session = [NSUserDefaults objectForKey:YXHeadCache];

    NSString *properties = @"";
    XMInfos *infos = [XMInfos sharedXMInfos];
    if (infos.roleID.length > 0 ||
        infos.roleName.length > 0 ||
        infos.roleLevel.length > 0 ||
        infos.psyLevel.length > 0 ||
        infos.serverID.length > 0 ||
        infos.serverName.length > 0){
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addValue:infos.roleID     key:@"role_id"];
        [params addValue:infos.roleName   key:@"role_name"];
        [params addValue:infos.roleLevel  key:@"role_level"];

        [params addValue:infos.psyLevel   key:@"pay_level"];
        [params addValue:infos.serverID   key:@"server_id"];
        [params addValue:infos.serverName key:@"server_name"];
        
        properties = [params jk_JSONString];
    }

    [YXNet uploadEvent:@"play_session" play_session:play_session properties:properties];
}

///// 防沉迷
//+ (void)heartWithHeartMode:(FxHEARTMode)mode result:(ResultBlock)result{
//
//    //开始请求数据
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    // 2.设置非校验证书模式
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    [manager.securityPolicy setValidatesDomainName:NO];
//
//    AFHTTPRequestSerializer *requset = [AFHTTPRequestSerializer serializer];
//    requset.stringEncoding = NSUTF8StringEncoding;
//    requset.timeoutInterval = 30;
//    manager.requestSerializer = requset;
//
//    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
//    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", @"text/javascript", nil];
//    manager.responseSerializer = response;
//
//    NSString *url = @"http://wap.gzjykj.com/api/heart-anti-addiction.php";
//
//    XMConfig *config = [XMConfig sharedXMConfig];
//    XMInfos  *infos  = [XMInfos sharedXMInfos];
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params addValue:infos.AppID key:@"appid"];
//    [params addValue:@"111111"   key:@"channel"];
//    [params addValue:config.user_name key:@"username"];
//
//    [params addValue:@(config.age) key:@"age"];
//    [params addValue:config.uid key:@"uid"];
//
//    switch (mode) {
//        case FxHEARTModeLogin: [params addValue:@"startHeart"  key:@"type"];
//            break;
//        case FxHEARTModeLogout: [params addValue:@"stopHeart"  key:@"type"];
//            break;
//        default:
//            break;
//    }
//
//    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSDictionary *state = responseObject[@"state"];
//        NSInteger code = [state[@"code"] integerValue];
//        NSString *msg = state[@"msg"];
//        if (code == 0) {
//            result(true,msg,nil);
//        } else {
//            YXError *err = [[YXError alloc] init];
//            err.code = @"1";
//            err.describe = msg;
//            result(false,nil,err);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YXError *err = [[YXError alloc] init];
//        err.code = @"404";
//        err.describe = @"请求失败";
//        result(false,nil,err);
//    }];
//}

@end
