//
//  YXAPP.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/10.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMConfig.h"
#import "FMDBManager.h"

@implementation XMConfig
singleton_implementation(XMConfig)

- (void)saveUser{
    
    self.log_name = [self.log_name lowercaseString];
    
    if (self.log_name.length == 0 || self.pwd.length == 0) {
        return;
    }
    
    NSDictionary *user = @{
        TableLeak_username : self.log_name,
        TableLeak_pwd      : self.pwd
    };
    
    NSArray *fmdb_user_keys = @[TableLeak_username,TableLeak_pwd];
    
    NSArray *list = [FMDBManager selectedData:TableUsers fieldKyes:fmdb_user_keys];
    
    // 存在，先删除
    for (NSDictionary *info in list) {
        if ([info[TableLeak_username] isEqualToString:self.log_name]) {
            // 有 先移除
            [FMDBManager deletedData:TableUsers key:TableLeak_username value:self.log_name];
            break;
        }
    }
    
    // 存储
    [FMDBManager insertData:TableUsers fieldDict:user];
}

- (NSArray *)users{
    NSArray *fmdb_user_keys = @[TableLeak_username,TableLeak_pwd];
    NSArray *list = [FMDBManager selectedData:TableUsers fieldKyes:fmdb_user_keys];
    return [[list reverseObjectEnumerator] allObjects];
}

- (void)removeWithName:(NSString *)name{
    if (name.length > 0) {
        [FMDBManager deletedData:TableUsers key:TableLeak_username value:name];
    }
}

- (NSDictionary *)userWithName:(NSString *)name{
    NSArray *fmdb_user_keys = @[TableLeak_username,TableLeak_pwd];
    NSArray *list = [FMDBManager selectedData:TableUsers fieldKyes:fmdb_user_keys key:TableLeak_username value:name];
    return  list.firstObject;
}

- (void)removeAllInfo{
    
    self.adult = 0;
    self.buoyState = @"";
    self.drurl = 0;
       
    self.email = @"";
    self.idCard = @"";
    self.isBindMobile = false;
    
    self.isOldUser = false;
    self.is_smrz = false;
    self.isbindemail = false;
    
    self.isguest = false;
    self.isnew = false;
    self.login_days = 0;
       
    self.mobile = @"";
    self.nick_name = @"";
    self.profile = @"";
       
    self.sid = @"";
    self.trueName = @"";
    self.trueNameSwitch = false;
       
    self.uid = @"";
    self.userSex = 0;
    self.user_name = @"";
    self.log_name = @"";
    
    self.pwd = @"";

    self.isLogin = false;
}

@end

