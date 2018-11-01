//
//  MDFmdb.m
//  QMainProject
//
//  Created by 李孟东 on 2018/10/25.
//  Copyright © 2018年 dareway. All rights reserved.
//

#import "MDFmdb.h"

static MDFmdb * tool = nil;

@implementation MDFmdb

/**
 * 可以存储数据类型 text integer blob boolean date
 * keyTypes 存储的字段 以及对应数据类型
 * keyValues 存储的字段 以及对应的值
 */

/**
 * 数据库工具单例
 *
 * @return 数据库工具对象
 */

+(MDFmdb *)shareTool {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[self alloc] init];
            
        }
        
    });
    return tool;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [super allocWithZone:zone];
            
        }
        
    });
    return tool;
    
}

/**
 * 创建数据库
 *
 * @param dbName 数据库名称(带后缀.sqlite)
 */
-(FMDatabase *)getDBWithDBName:(NSString *)dbName {
    
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);// 沙盒路径
    NSString *dbPath = [library[0] stringByAppendingPathComponent:dbName];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"sqlite地址-->%@",dbPath);
    if (![db open]) {
        NSLog(@"无法获取数据库");
        return nil;
        
    }
    
    [self closeDatabase:db];
    
    return db;
    
}

/**
 * 给指定数据库建表
 *
 * @param db 指定数据库对象
 * @param tableName 表的名称
 * @param keyTypes 所含字段以及对应字段类型 字典
 */
-(void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure {
    
    if ([self isOpenDatabese:db]) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, ",tableName]];
        int count = 0;
        for (NSString *key in keyTypes) {
            count++;
            
            [sql appendString:key];
            [sql appendString:@" "];
            [sql appendString:[keyTypes valueForKey:key]];
            if (count != [keyTypes count]) {
                [sql appendString:@" NOT NULL, "];
            }
        }
        [sql appendString:@");"];
        
        BOOL result = [db executeUpdate:sql];
        
        [self closeDatabase:db];
        
        if (result) {
            //建表成功
            success();
        } else {
            //建表失败
            failure(CUSTOM_ERROR_CODE, @"操作失败");
        }
    }
    
//    failure(CUSTOM_ERROR_CODE, @"数据库打开失败");
}

/**
 * 给指定数据库的表添加值
 *
 * @param db 数据库名称
 * @param keyValues 字段及对应的值
 * @param tableName 表名
 */
-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure {
    
    if ([self isOpenDatabese:db]) {
        NSArray *keys = [keyValues allKeys];
        NSArray *values = [keyValues allValues];
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (", tableName]];
        
        NSInteger count = 0;
        for (NSString *key in keys) {
            count ++;
            
            [sql appendString:key];
            if (count < [keys count]) {
                [sql appendString:@", "];
                
            }
            
        }
        
        [sql appendString:@") VALUES ("];
        
        for (int i = 0; i < [values count]; i++) {
            
            [sql appendString:@"?"];
            
            if (i < [values count] - 1) {
                [sql appendString:@","];
                
            }
            
        }
        [sql appendString:@");"];
        
        BOOL result = [db executeUpdate:sql withArgumentsInArray:values];
        
        [self closeDatabase:db];
        
        if (result) {
            //插入数据成功
            success();
        } else {
            //插入数据失败
            failure(CUSTOM_ERROR_CODE, @"操作失败");
        }
    }
    
//    failure(CUSTOM_ERROR_CODE, @"数据库打开失败");
}

/**
 *查询数据库表中的所有值 根据传入的page，count取出
 *
 * @param db 数据库名称
 * @param keyTypes 查询字段以及对应字段类型 字典
 * @param page 页码(从1开始)
 * @param count 数量
 * @param tableName 表名称
 * @return 查询得到数据
 */
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes page:(NSInteger)page count:(NSInteger)count fromTable:(NSString *)tableName {
    
    if ([self isOpenDatabese:db]) {
        NSInteger limitMin;
        NSInteger limitMax;
        limitMin = count * (page - 1);
        limitMax = limitMin + count;
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT %ld,%ld",tableName, limitMin, limitMax]];
        NSLog(@"---->%@",[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %ld,%ld",tableName, limitMin, limitMax]);
        return [self getArrWithFMResultSet:result keyTypes:keyTypes];
        
    }else return nil;
}

/**
 * 判断有没有该字段
 */
- (BOOL)DHisExistObjectInDataBase:(FMDatabase *)db fromTable:(NSString *)tableName colunm:(NSString *)colunm identify:(NSString *)identify {
    
    if ([self isOpenDatabese:db]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select count(1) from %@ where %@ = '%@'",tableName,colunm,identify]];
        int a = 0;
        while ([rs next]) {
            a = [rs intForColumn:@"count(1)"];
            
        }
        return a > 0 ? YES : NO;
        
    }else return NO;
}

/**
 * 判断有没表
 */
- (BOOL)DHisExistTable:(NSString *)tableName DataBase:(FMDatabase *)db {
    
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next]) {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            // NSLog(@"isTableOK %d", count);
            if (0 == count) {
                return NO;
                
            } else {
                return YES;
                
            }
            
        }
        return NO;
    }
    
    return NO;
}

/**
 *
 删除表 */
-(void)dropTableFormDatabase:(FMDatabase *)db table:(NSString *)tableName success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure {
    
    if ([self isOpenDatabese:db]) {
       BOOL result = [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE '%@'",tableName]];
        
        if (result) {
            success();
        } else {
            failure(CUSTOM_ERROR_CODE, @"操作失败");
        }
    }
    
//    failure(CUSTOM_ERROR_CODE, @"数据库打开失败");
}

/**
 * 删除指定表(数据库) 中的 单条数据 (单一指定条件)
 */
-(void)deleteOneDataFormDatabase:(FMDatabase *)db fromTable:(NSString *)tableName whereConditon:(NSDictionary *)condition {
    
    if ([self isOpenDatabese:db]) { [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@';",tableName,[condition allKeys][0], [condition allValues][0]]];
        
    }
    
}

// 私有方法

#pragma mark -- CommonMethod 确定类型
-(NSArray *)getArrWithFMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes {
    
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyTypes.count; i++) {
            NSString *key = [keyTypes allKeys][i];
            NSString *value = [keyTypes valueForKey:key];
            if ([value isEqualToString:@"string"] || [value isEqualToString:@"string"]) {
                // 字符串
                [tempDic setValue:[result stringForColumn:key] forKey:key];
                
            }else if([value isEqualToString:@"blob"] || [value isEqualToString:@"BLOB"]) {
                // 二进制对象
                [tempDic setValue:[result dataForColumn:key] forKey:key];
                
            }else if ([value isEqualToString:@"integer"] || [value isEqualToString:@"INTEGER"]) {
                // 带符号整数类型
                [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]]forKey:key];
                
            }else if ([value isEqualToString:@"boolean"] || [value isEqualToString:@"BOOLLEAN"]) {
                // BOOL型
                [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
                
            }else if ([value isEqualToString:@"date"] || [value isEqualToString:@"DATA"]) {
                // date
                [tempDic setValue:[result dateForColumn:key] forKey:key];
                
            }
            
        }
        [tempArr addObject:tempDic];
        
    }
    return tempArr;
    
}

#pragma mark -- 数据库 是否已经 打开
-(BOOL)isOpenDatabese:(FMDatabase *)db {
    if (![db open]) {
        [db open];
        
    }
    return YES;
    
}

- (void)closeDatabase:(FMDatabase *)db {
    
    [db close];
}

@end
