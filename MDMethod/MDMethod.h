//
//  MDMethod.h
//  Unicorn_Aged
//
//  Created by 李孟东 on 2018/7/24.
//  Copyright © 2018年 dareway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>
#import "MDFmdbMethod.h"
#import "MDFmdb.h"

typedef void(^FieldChangeHandle)(NSString *fieldOutput);

typedef NS_ENUM(NSInteger, MDMethod_APP_NAME) {
    
    MDMethod_APP_NAME_Alipay = 1,               //支付宝
    MDMethod_APP_NAME_Wechat,                   //微信
    MDMethod_APP_NAME_QQ,                       //QQ
    MDMethod_APP_NAME_Sina,                     //新浪微博
};

@interface MDMethod : NSObject

#pragma mark 工具类
//校验字符串
#define MDMethodCheckString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? @"" : str )

//字符串转nsinteger
#define MDMethodStrToInt(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? 0 : [str integerValue])

//字符串转cgfloat
#define MDMethodStrTofloat(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? 0. : [str floatValue])

//nsinteger转字符串
#define MDMethodIntToStr(figure) ([NSString stringWithFormat:@"%ld", figure])

//cgfloat转字符串
#define MDMethodFloatToStr(figure) ([NSString stringWithFormat:@"%lf", figure])

/// 获取启动图
+ (UIImage *)MD_getLaunchImage;

/// 获取APP Icon
+ (UIImage *)MD_getAppIcon;

/// 获取文本高度
+ (CGFloat)queryTextHeightByString:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize;

/// 获取文本宽度
+ (CGFloat)queryTextWidthByString:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize;

/// 判断是否安装程序
+ (BOOL)haveInstallApp:(MDMethod_APP_NAME)appName;

/// 根据传入的可变数组、关键字排序
+ (void)sortArray:(NSMutableArray *)array With:(NSString *)keyword;

/// 根据classname获取控件
+ (UIView *)generateViewWithNib:(NSString *)className;

/// md5加密
+ (NSString *)md5:(NSString *)input;

/// URLEncoded
+ (NSString *)URLEncodedStringWithUrl:(NSString *)url;

/// URLdecoded
+ (NSString *)URLdecodedStringWithUrl:(NSString *)url;

/// 保存倒计时
+ (void)saveVerifyCodeTime;

/// 获取倒计时时间
+ (NSInteger)getVerifyCodeTime;

/// 跳转登录
+ (void)presentLoginViewController;

/// json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/// object转json
+ (NSString *)jsonStringWithObject:(id)object;

/// float保留2位小数
+ (CGFloat)reserveDecimals:(CGFloat)floatNum;

//图片转data
/**
 * 压缩图片到指定文件大小
 *
 * @param image 目标图片
 * @param maxLength 目标大小（kb）
 *
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)maxLength;

/// 时间戳 - 时间
/// 获取当前时间戳
+ (NSString *)getCurrentStamp;

/// 时间戳转NSDateComponents
+ (NSDateComponents *)getDateStringWithTimeStamp:(NSInteger)stamp;

/// 计算两个时间戳相差的时间，转NSDateComponents
+ (NSDateComponents *)getTimeInterval:(NSInteger)startStamp endTime:(NSInteger)endStamp;

/// 计算传入的时间戳与当前时间差，转NSDateComponents
+ (NSDateComponents *)getTimeInterval:(NSInteger)stamp;

/// 时间转时间戳
+ (NSString *)getTimeStrWithString:(NSString *)str;

/// 时间转NSDateComponents
+ (NSDateComponents *)getDateComponentsWithString:(NSString *)str;

/// 比较传入的时间戳是否晚于当前时间
+ (BOOL)compareCurrentTime:(NSInteger)stamp;

/// 获取Caches目录路径
+ (NSString *)getCachesPath;

/*s*
 *  获取path路径下文件夹的大小
 *
 *  @param path 要获取的文件夹 路径
 *
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;

/*
 
 根据传入的字符串获取二维码图片
 
 */

+ (UIImage *)getErCodeWithString:(NSString *)dataString;

/*
 
 * 传入数组、关键字(非必传，如果不传，则认为数组元素为字符串)，根据拼音排序，并返回一个浅排序数组（只是单纯排序），一个是深排序（排序，并按首字母分类）
 
 */
+ (NSArray *)getSortArrayByArray:(NSArray *)inpuArray keyword:(NSString *)keyword;

/*
 
 * 传入数组、关键字(非必传，如果不传，则认为数组元素为字符串)，根据拼音排序，并返回一个深排序（排序，并按首字母分类）
 
 */
+ (NSArray *)getDeepSortArrayByArray:(NSArray *)inpuArray keyword:(NSString *)keyword;


//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString;

//model转化为字典
+ (NSDictionary *)dicFromObject:(NSObject *)object;



#pragma mark UI类
/// 颜色渐变器
+ (CAGradientLayer *)generateGradientLayerWithBounds:(CGRect)bounds
                                          startPoint:(CGPoint)startPoint
                                            endPoint:(CGPoint)endPoint
                                              colors:(NSArray *)colors
                                       seperatePoint:(NSArray *)points;

/// code转image
+ (UIImage *)generateQRCodeWith:(NSString *)code;

/// code转image 并根据传入的size设置image
+ (UIImage *)generateBarCodeWith:(NSString *)code size:(CGSize)size;

/// 按钮设置 图片在上，文字在下
+ (void)setCustomButton:(UIButton *)button image:(NSString *)imageStr title:(NSString *)title titleColor:(UIColor *)color titleFont:(CGFloat)font interval:(CGFloat)interval;

/// 按钮设置 图片在右，文字在左
+ (void)setCustomAroundButton:(UIButton *)button image:(NSString *)imageStr title:(NSString *)title titleColor:(UIColor *)color titleFont:(CGFloat)font;

/// 按钮设置 带边框，非圆角
+ (void)setCustomBorderButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor title:(NSString *)title borderColor:(UIColor *)borderColor titleColor:(UIColor *)color titleFont:(CGFloat)font;

/// 按钮设置 带边框，圆角
+ (void)setCustomBorderCornerButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor title:(NSString *)title borderColor:(UIColor *)borderColor titleColor:(UIColor *)color titleFont:(CGFloat)font;

/// 获得自定义按钮
+ (UIButton *)getCustomButton:(CGRect)customFram customTitle:(NSString *)customTitle customBgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor titleFont:(CGFloat)titleFont cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)selecter;

/// 根据传入的文字、颜色、size、等获得富文本(只改变文字颜色)
+ (NSMutableAttributedString *)getAttributedString:(NSString *)str attriColor:(UIColor *)attriColor normalColr:(UIColor *)normalColor font:(CGFloat)attriFont attriSize:(NSInteger)attriSize;

/// 根据传入的文字、颜色、size、等获得富文本(改变文字颜色、字体)
+ (NSMutableAttributedString *)getAttributedString:(NSString *)str attriColor:(UIColor *)attriColor normalColr:(UIColor *)normalColor attriFont:(CGFloat)attriFont normalFont:(CGFloat)normalFont attriSize:(NSInteger)attriSize;

/// 给view添加通用的手势
+ (void)addNormalTapGesture:(UIView *)view target:(id)target action:(SEL)selection;

/// 获取通用的MJRefreshNormalHeader
+ (MJRefreshNormalHeader *)getMJRefreshNormalHeaderWithTarget:(id)target action:(SEL)action;

/// 获取通用的MJRefreshAutoNormalFooter
+ (MJRefreshAutoNormalFooter *)getMJRefreshAutoNormalFooterWithTarget:(id)target action:(SEL)action;

/// 根据传入的nibname和frame获取view
+ (UIView *)getNibViewByNibName:(NSString *)nibName frame:(CGRect)frame;

/// 给textfield添加监听
+ (void)addMonitorForTextField:(UITextField *)textField fieldChangeHandle:(FieldChangeHandle)fieldChangeHandle;

/// 查看大图
+ (void)showDetailImage:(UIImage *)detailImage;
+ (void)showDetailImageWithURL:(NSString *)imgUrl;

/// 彩色图片转换为黑白图片
+ (UIImage*)grayImage:(UIImage*)sourceImage;

/// 修改图片颜色
+ (void)resetImageViewTintColorWithImageView:(UIImageView *)imageView image:(UIImage *)image tintcolor:(UIColor *)tintcoclor;

/// 修改按钮图片颜色
+ (void)resetButtonImageViewTintColorWithImageView:(UIButton *)button image:(UIImage *)image tintcolor:(UIColor *)tintcoclor;

/// 显示空白页面
+ (void)showEmptViewWithEmptImage:(NSString *)emptImage emptStr:(NSString *)emptStr superView:(UIView *)superView;

/// 删除空白页面
+ (void)removeEmptViewFromSuperView:(UIView *)superView;


#pragma mark 我的足迹（操作数据库）
/// 添加一条数据到数据库表中
+ (void)addGoodsToTableWithGoodsId:(NSString *)goodsId goodsName:(NSString *)goodsName goodsLogo:(NSString *)goodsLogo goodsPrice:(NSString *)goodsPrice goodsSales:(NSString *)goodsSales success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure;

/// 取出数据
+ (void)getGoodsFromTableWithPage:(NSInteger)page success:(void(^)(NSArray *goodsList))success failure:(MDFmdbFailureHandler)failure;

/// 删除所有数据
+ (void)deleteAllGoodsFromTableCompleteSuccess:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure;

@end
