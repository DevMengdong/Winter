//
//  MDFmdb.h
//  QMainProject
//
//  Created by 李孟东 on 2018/10/25.
//  Copyright © 2018年 dareway. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>

typedef void(^MDFmdbSuccessHandler)(void);

typedef void(^MDFmdbFailureHandler)(NSString *errorCode, NSString *errorDes);

@interface MDFmdb : NSObject

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

+(MDFmdb *)shareTool;

/**
 * 创建数据库
 *
 * @param dbName 数据库名称(带后缀.sqlite)
 */
-(FMDatabase *)getDBWithDBName:(NSString *)dbName;

/**
 * 给指定数据库建表
 *
 * @param db 指定数据库对象
 * @param tableName 表的名称
 * @param keyTypes 所含字段以及对应字段类型 字典
 */
-(void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure;

/**
 * 给指定数据库的表添加值
 *
 * @param db 数据库名称
 * @param keyValues 字段及对应的值
 * @param tableName 表名
 */
-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure;

/**
 *查询数据库表中的所有值 根据传入的page，count取出
 *
 * @param db 数据库名称
 * @param keyTypes 查询字段以及对应字段类型 字典
 * @param page 页码
 * @param count 数量
 * @param tableName 表名称
 * @return 查询得到数据
 */
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes page:(NSInteger)page count:(NSInteger)count fromTable:(NSString *)tableName;

/**
 * 判断有没有该字段
 */
- (BOOL)DHisExistObjectInDataBase:(FMDatabase *)db fromTable:(NSString *)tableName colunm:(NSString *)colunm identify:(NSString *)identify;

/**
 * 判断有没表
 */
- (BOOL)DHisExistTable:(NSString *)tableName DataBase:(FMDatabase *)db;

/**
 *
 删除表 */
-(void)dropTableFormDatabase:(FMDatabase *)db table:(NSString *)tableName success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure;

/**
 * 删除指定表(数据库) 中的 单条数据 (单一指定条件)
 */
-(void)deleteOneDataFormDatabase:(FMDatabase *)db fromTable:(NSString *)tableName whereConditon:(NSDictionary *)condition;

@end
