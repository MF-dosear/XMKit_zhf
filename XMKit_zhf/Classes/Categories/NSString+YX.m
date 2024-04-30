//
//  NSString+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/7.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "NSString+YX.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#include <CommonCrypto/CommonCrypto.h>

@implementation NSString (YX)

- (BOOL)isNumber{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val = 0;
    return [scan scanInt:&val] && scan.isAtEnd;
}

- (BOOL)isValidString{
    if ([self isKindOfClass:[NSNull class]]) {
        return false;
    }
    return self.length > 0 ? true : false;
}

- (NSString *)removeSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)randomWithLength:(NSInteger)length{
    
    if (length <= 0) {
        return @"";
    }
    
    NSString *ramdom;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i ; i ++) {
        int a = (arc4random() % 58);
        if (a > 47) {
            char c = (char)a;
            [array addObject:[NSString stringWithFormat:@"%c",c]];
            if (array.count == length) {
                break;
            }
        } else continue;
    }
    ramdom = [array componentsJoinedByString:@""];//这个是把数组转换为字符串
    return ramdom;
}

+ (NSString *)timeWithDate{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]] stringValue];;
}


//+ (NSString *)WIFISSID{
//    
//    NSString *ssid = nil;
//    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
//    for (NSString *ifnam in ifs) {
//        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        if (info[@"SSID"]) {
//            ssid = info[@"SSID"];
//        }
//    }
//    return ssid;
//}

+ (NSString *)bodyWithInfo:(NSDictionary *)parameter{
    
    NSString *jsonStr = @"";
    if (!parameter || ![parameter isKindOfClass:[NSDictionary class]]) {
        return jsonStr;
    }
    NSArray  *arrKeys = [parameter allKeys];
    for (int i = 0 ; i < arrKeys.count ; i++)
    {
        NSString * key   = arrKeys[i];
        NSString * value = [parameter valueForKey:key];
        if (i+1 == arrKeys.count) {
            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[NSString fmq_encodeValue:value]]];
        } else {
            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[NSString fmq_encodeValue:value]]];
        }
    }
    return jsonStr;
}

#pragma mark - 特殊字符处理
+ (NSString *)fmq_encodeValue:(NSString *)string{
    
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "] invertedSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

// Custom method to calculate the SHA-256 hash using Common Crypto.
+ (NSString *)hashedValueForAccountName:(NSString *)userAccountName{
    const int HASH_SIZE = 32;
    unsigned char hashedChars[HASH_SIZE];
    const char *accountName = [userAccountName UTF8String];
    size_t accountNameLen = strlen(accountName);
 
    // Confirm that the length of the user name is small enough
    // to be recast when calling the hash function.
    if (accountNameLen > UINT32_MAX) {
        NSLog(@"Account name too long to hash: %@", userAccountName);
        return nil;
    }
    CC_SHA256(accountName, (CC_LONG)accountNameLen, hashedChars);
 
    // Convert the array of bytes into a string showing its hex representation.
    NSMutableString *userAccountHash = [[NSMutableString alloc] init];
    for (int i = 0; i < HASH_SIZE; i++) {
        // Add a dash every four bytes, for readability.
        if (i != 0 && i%4 == 0) {
            [userAccountHash appendString:@"-"];
        }
        [userAccountHash appendFormat:@"%02x", hashedChars[i]];
    }
    return userAccountHash;
}

@end
