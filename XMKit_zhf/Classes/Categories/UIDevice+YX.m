//
//  UIDevice+YX.m
//  YXunk
//
//  Created by Hello197309 on 2020/4/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "UIDevice+YX.h"

#import <sys/utsname.h>
#include <sys/sysctl.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (YX)

+ (NSString *)modelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
       if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
       if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
       if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s (A1387/A1431)";
       if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
       if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
       if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
       if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
       if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
       if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
       if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
       if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
       if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
       if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
       if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (Global)";
       if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (GSM)";
       if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (Global)";
       if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (GSM)";
       if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8 (Global)";
       if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8 (GSM)";
       if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus (Global)";
       if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus (GSM)";
       if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X (Global)";
       if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X (GSM)";
       if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
       if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
       if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
       if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
       if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
       if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
       if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
       if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
       if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
       
       if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
       
       if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
       if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
       if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
       if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
       if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
       if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
       if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
       
       if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
       if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
       if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
       if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
       if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
       if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
       
       if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
       if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
       if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
       if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
       if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
       if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
       
       if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
       if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
       return platform;
}

+ (NSString *)brand{
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone:   return @"iPhone";
            break;
        case UIUserInterfaceIdiomPad:     return @"iPad";
            break;
        case UIUserInterfaceIdiomTV:      return @"iTV";
            break;
        case UIUserInterfaceIdiomCarPlay: return @"iCarPlay";
            break;
        default:                          return LocalizedString(@"Unknown device");
            break;
    }
}

+ (NSString *)model{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size); //••设备编码
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

static time_t bootSecTime(){
    
    struct timeval boottime;
    size_t len = sizeof(boottime);
    int mib[2] = { CTL_KERN, KERN_BOOTTIME};
    
    if( sysctl(mib, 2, &boottime, &len, NULL, 0) < 0) {
        return 0;
    }
    return boottime.tv_sec;
}

+ (NSString *)bootTimeInSec {
    return [NSString stringWithFormat:@"%ld",bootSecTime()];
}

+ (NSString *)countryCode{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

+ (NSString *)language {
    
    NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages] objectAtIndex:0];
    } else {
        language = [locale objectForKey:NSLocaleLanguageCode]; }
    return language;
}

+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString *)machine {
    
    NSString *machine = getSystemHardwareByName(SIDFAMachine);
    return machine == nil ? @"" : machine;
}

static const char *SIDFAMachine = "hw.machine";
static NSString *getSystemHardwareByName(const char *typeSpecifier) {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL,0);
    NSString *results = [NSString stringWithUTF8String:answer];
    free(answer);
    return results;
}

+ (NSString *)memory{
    return [NSString stringWithFormat:@"%lld", [NSProcessInfo processInfo].physicalMemory];
}

+ (NSString *)disk {
    int64_t space = -1;
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    
    if (!error) {
        space = [[attrs objectForKey:NSFileSystemSize] longLongValue];
    }
    if(space < 0) {
        space = -1;
    }
    return [NSString stringWithFormat:@"%lld",space];
}

+ (NSString *)sysFileTime {
    
    NSString *result = nil;
    NSString *information = @"L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0";
    NSData *data=[[NSData alloc] initWithBase64EncodedString:information options:0] ;
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dataString error:&error];
    if (fileAttributes) {
        id singleAttibute = [fileAttributes objectForKey:NSFileCreationDate];
        if ([singleAttibute isKindOfClass:[NSDate class]]) {
            NSDate *dataDate = singleAttibute;
            result = [NSString stringWithFormat:@"%f",[dataDate timeIntervalSince1970]];
        }
    }
    return result;
}

static const char *SIDFAModel = "hw.model";
+ (NSString *)model_CAID{
    NSString *model = getSystemHardwareByName(SIDFAModel);
    return model == nil ? @"" : model;
}

+ (NSString *)timeZone {
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT;
    return [NSString stringWithFormat:@"%ld",(long)offset];
}

//运营商
+ (NSString* )carrierInfo {
    
//    #if TARGET_IPHONE_SIMULATOR
//    return @"SIMULATOR";
//    #else
//    static dispatch_queue_t _queue;
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        _queue = dispatch_queue_create([[NSString stringWithFormat:@"com.carr.%@" , self] UTF8String], NULL); });
//    __block NSString * carr = nil;
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); dispatch_async(_queue, ^(){
//        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
//        CTCarrier *carrier = nil;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.1) {
//            if ([info respondsToSelector:@selector (serviceSubscriberCellularProviders)]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunguarded-availability-new"
//                NSArray *carrierKeysArray = [info.serviceSubscriberCellularProviders .allKeys sortedArrayUsingSelector:@selector(compare:)];
//                carrier = info.serviceSubscriberCellularProviders [carrierKeysArray.firstObject];
//                if (!carrier.mobileNetworkCode) {
//                    carrier = info.serviceSubscriberCellularProviders [carrierKeysArray.lastObject];
//
//                }
//#pragma clang diagnostic pop
//
//            }
//
//        }if(!carrier) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//            carrier = info.subscriberCellularProvider;
//#pragma clang diagnostic pop
//
//        }if (carrier != nil) {
//            NSString *networkCode = [carrier mobileNetworkCode];
//            NSString *countryCode = [carrier mobileCountryCode];
//            if (countryCode && [countryCode isEqualToString:@"460"] && networkCode ) {
//                if ([networkCode isEqualToString:@"00"] || [networkCode isEqualToString:@"02"] || [networkCode isEqualToString:@"07"] || [networkCode isEqualToString:@"08"]) {
//                carr= @"中国移动";
//
//            }
//                if ([networkCode isEqualToString:@"01"] || [networkCode isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
//                carr= @"中国联通";
//
//            }
//                if ([networkCode isEqualToString:@"03"]
//|| [networkCode isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
//                carr= @"中国电信";
//            }
//                if ([networkCode isEqualToString:@"04"]) { carr= @"中国卫通"; }
//                if ([networkCode isEqualToString:@"20"]) {
//                    carr= @"中国铁通";
//            }
//
//            }else {
//                carr = [carrier.carrierName copy];
//
//            }
//
//        }if (carr.length <= 0) {
//            carr =@"unknown";
//
//        }dispatch_semaphore_signal(semaphore);
//
//    });
//    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC); dispatch_semaphore_wait(semaphore, t);
//    return [carr copy];
//#endif
    return @"";
}

@end
