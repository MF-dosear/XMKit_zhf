//
//  FMDBManager.m
//  PSQDK
//
//  Created by dosear on 2021/10/30.
//  Copyright © 2020 dosear. All rights reserved.
//

#import "FMDBManager.h"

#import "FMDB.h"

@interface FMDBManager ()

@property (nonatomic,strong) FMDatabase *db;

@end

@implementation FMDBManager

static FMDBManager *instance;

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingString:@"/fmdb.sqlite"];
        NSLog(@"%@", path);
        instance.db = [[FMDatabase alloc] initWithPath:path];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

+ (BOOL)createTable:(NSString *)tableName fieldDict:(NSDictionary *)fieldDict{
    
    BOOL isCreate = false;
    if ([instance.db open]) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ",tableName];
        NSArray *keys = fieldDict.allKeys;
        
        for (int i=0; i<keys.count; i++) {
            NSString *key = keys[i];
            NSString *value = fieldDict[key];
            if (i != keys.count - 1) {
                sql = [NSString stringWithFormat:@"%@%@ %@, ",sql,key,value];
            } else {
                sql = [NSString stringWithFormat:@"%@%@ %@)",sql,key,value];
            }
        }
        isCreate = [instance.db executeUpdate:sql];
    }
    [instance.db close];
    
    NSString *text = [NSString stringWithFormat:@"FMDB:%@表创建%@！",tableName,isCreate?@"成功":@"失败"];
    NSLog(@"%@", text);

    return isCreate;
}

+ (BOOL)insertData:(NSString *)tableName fieldDict:(NSDictionary *)fieldDict{
    
    BOOL isInsert = false;
    if ([instance.db open]) {
        NSString *first = [NSString stringWithFormat:@"INSERT INTO '%@' (",tableName];
        NSString *last  = @" VALUES(";
        NSArray *keys = fieldDict.allKeys;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<keys.count; i++) {
            NSString *key = keys[i];
            NSString *value = fieldDict[key];
            [arr addObject:value];
            
            if (i != keys.count - 1) {
                first = [NSString stringWithFormat:@"%@%@,",first,key];
                last = [NSString stringWithFormat:@"%@?,",last];
            } else {
                first = [NSString stringWithFormat:@"%@%@)",first,key];
                last = [NSString stringWithFormat:@"%@?)",last];
            }
        }
        NSString *sql = [first stringByAppendingString:last];
        isInsert = [instance.db executeUpdate:sql values:arr error:nil];
    }
    [instance.db close];
    
    NSString *text = [NSString stringWithFormat:@"FMDB:%@表插入数据%@！",tableName,isInsert?@"成功":@"失败"];
    NSLog(@"%@", text);

    return isInsert;
}

+ (BOOL)updateData:(NSString *)tableName filedDict:(NSDictionary *)fieldDict key:(NSString *)key value:(id)value{
    BOOL isUpdate = false;
    if ([instance.db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
        NSArray *keys = fieldDict.allKeys;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<keys.count; i++) {
            NSString *key = keys[i];
            NSString *value = fieldDict[key];
            [arr addObject:value];
            
            if (i != keys.count - 1) {
                sql = [NSString stringWithFormat:@"%@%@ = ?,",sql,key];
            } else {
                sql = [NSString stringWithFormat:@"%@%@ = ?",sql,key];
            }
        }
        sql = [NSString stringWithFormat:@"%@ WHERE %@ = ?",sql,key];
        [arr addObject:value];
        isUpdate = [instance.db executeUpdate:sql values:arr error:nil];
    }
    [instance.db close];
    
    NSString *text = [NSString stringWithFormat:@"FMDB:%@表修改数据%@！",tableName,isUpdate?@"成功":@"失败"];
    NSLog(@"%@", text);
    
    return isUpdate;
}

+ (NSArray <NSDictionary *>*)selectedData:(NSString *)tableName fieldKyes:(NSArray <NSString *>*)fieldKyes{
    NSMutableArray *arr = [NSMutableArray array];
    if ([instance.db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *set = [instance.db executeQuery:sql];
        while ([set next]) {
            NSMutableDictionary *fieldDict = [NSMutableDictionary dictionary];
            for (NSString *key in fieldKyes) {
                [fieldDict addValue:[set stringForColumn:key] key:key];
            }
            [arr addObject:fieldDict];
        }
    }
    [instance.db close];
    return arr;
}

+ (NSArray <NSDictionary *>*)selectedData:(NSString *)tableName fieldKyes:(NSArray <NSString *>*)fieldKyes key:(NSString *)key value:(id)value{
    NSMutableArray *arr = [NSMutableArray array];
    if ([instance.db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",tableName,key];
        FMResultSet *set = [instance.db executeQuery:sql values:@[value] error:nil];
        while ([set next]) {
            NSMutableDictionary *fieldDict = [NSMutableDictionary dictionary];
            for (NSString *key in fieldKyes) {
                [fieldDict addValue:[set stringForColumn:key] key:key];
            }
            [arr addObject:fieldDict];
        }
    }
    [instance.db close];
    return arr;
}

+ (BOOL)deletedData:(NSString *)tableName key:(NSString *)key value:(id)value{
    BOOL isDelete = false;
    if ([instance.db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = ?",tableName,key];
        isDelete = [instance.db executeUpdate:sql values:@[value] error:nil];
    }
    [instance.db close];

    NSString *text = [NSString stringWithFormat:@"FMDB:%@表删除数据%@！",tableName,isDelete?@"成功":@"失败"];
    NSLog(@"%@", text);
    
    return isDelete;
}

+ (BOOL)deletedTable:(NSString *)tableName{
    BOOL isDelete = false;
    if ([instance.db open]) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
        isDelete = [instance.db executeUpdate:sql];
    }

    NSString *text = [NSString stringWithFormat:@"FMDB:%@表删除表%@！",tableName,isDelete?@"成功":@"失败"];
    NSLog(@"%@", text);
    
    [instance.db close];
    return isDelete;
}

@end
