//
//  MDMethod.m
//  Unicorn_Aged
//
//  Created by 李孟东 on 2018/7/24.
//  Copyright © 2018年 dareway. All rights reserved.
//

#import "MDMethod.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "QMainDetailImageView.h"
#import "QMainEmptView.h"

@interface MDMethod()

@property (nonatomic, copy) FieldChangeHandle fieldChangeHandle;

@end

@implementation MDMethod

static MDMethod *_instance;


+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareMDMethodManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MDMethod alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

+ (UIImage *)MD_getLaunchImage {
    
    CGSize viewSize = CGSizeMake(MDKScreenWidth, MDKScreenHeight);
    NSString* viewOrientation = @"Portrait";
    NSString* launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for(NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
            return [UIImage imageNamed:launchImage];
        }
    }
    
    return nil;
}

+ (UIImage *)MD_getAppIcon {
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    UIImage* image = [UIImage imageNamed:icon];

    return image;
}

+ (CGFloat)queryTextHeightByString:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize {
    
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(width,CGFLOAT_MAX);
    // 获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    return actualsize.height;
    
}

+ (CGFloat)queryTextWidthByString:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize {
    
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(width,CGFLOAT_MAX);
    // 获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    return actualsize.width;
    
}

+ (BOOL)haveInstallApp:(MDMethod_APP_NAME)appName {
    switch (appName) {
        case MDMethod_APP_NAME_Alipay:
        {
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
//                
//                return YES;
//            }
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                
                return YES;
            }
            break;
        }
        case MDMethod_APP_NAME_Wechat:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                
                return YES;
            }
            break;
        }
        case MDMethod_APP_NAME_QQ:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                return YES;
            }
            break;
        }
        case MDMethod_APP_NAME_Sina:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) {
                
                return YES;
            }
            break;
        }
        default:
            break;
    }
    
    return NO;
}

+ (CAGradientLayer *)generateGradientLayerWithBounds:(CGRect)bounds
                                          startPoint:(CGPoint)startPoint
                                            endPoint:(CGPoint)endPoint
                                              colors:(NSArray *)colors
                                       seperatePoint:(NSArray *)points {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bounds;
    
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    
    //设置颜色数组
    layer.colors = colors;
    //设置颜色分割点（范围：0-1）
    layer.locations = points;
    
    return layer;
}

+ (void)sortArray:(NSMutableArray *)array With:(NSString *)keyword {
    [array sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        NSString *index1 = [obj1 objectForKey:keyword];
        NSString *index2 = [obj2 objectForKey:keyword];
        
        return index1 < index2;
    }];
}

+ (UIView *)generateViewWithNib:(NSString *)className {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    Class targetClass = NSClassFromString(className);
    for (UIView *view in views) {
        if ([view isMemberOfClass:targetClass]) {
            return view;
        }
    }
    return nil;
}

+ (void)saveVerifyCodeTime {
    NSInteger now = (NSInteger)[[NSDate date] timeIntervalSince1970];
    [DWUserDefaults saveTimerTime:now];
}

+ (NSInteger)getVerifyCodeTime {
    return [DWUserDefaults getTimerTime];
}

+ (void)presentLoginViewController {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
//    [result presentViewController:[[QMainBaseNavigationController alloc] initWithRootViewController:[UALoginViewController new]] animated:YES completion:^{
//
//    }];
}

+ (UIImage *)generateQRCodeWith:(NSString *)code {
    // 1.将字符串转换成NSData
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 3.恢复默认
    [filter setDefaults];
    
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 5.获取滤镜输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 6.此时生成的还是CIImage，可以通过下面方式生成一个固定大小的UIImage
    CGFloat size = 200;
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 7.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 8.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)generateBarCodeWith:(NSString *)code size:(CGSize)size {
    // 1.将字符串转换成NSData
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.创建条形码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    // 3.恢复滤镜的默认属性
    [filter setDefaults];
    
    // 4.设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    [filter setValue:[NSNumber numberWithInteger:4] forKey:@"inputQuietSpace"];
    
    // 5.获得滤镜输出的图像
    CIImage *urlImage = [filter outputImage];
    
    // 6.将CIImage 转换为UIImage
    
    UIImage *result = [self resizeCodeImage:urlImage withSize:size];
    
    return result;
}

+ (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size {
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    }else{
        return nil;
    }
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)URLEncodedStringWithUrl:(NSString *)url {
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!*'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
    
//    NSString *encodeURL;
//    if (@available(iOS 9.0, *)) {
//
//        encodeURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    } else {
//
//        encodeURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//
//    return encodeURL;
}

+ (NSString *)URLdecodedStringWithUrl:(NSString *)url  {
    
    NSString *decodeURL;
    if (@available(iOS 9.0, *)) {
        
         decodeURL = [url stringByRemovingPercentEncoding];
    } else {
        
        decodeURL = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return decodeURL;
}

/// 按钮设置 图片在上，文字在下
+ (void)setCustomButton:(UIButton *)button image:(NSString *)imageStr title:(NSString *)title titleColor:(UIColor *)color titleFont:(CGFloat)font interval:(CGFloat)interval {
//
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
//    button.titleLabel.adjustsFontSizeToFitWidth = YES;
//
//    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(button.mdk_width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
//
//    CGFloat titleWidth = titleSize.width;
//    CGFloat titleHeight = titleSize.height;
//    CGFloat imageWidth = button.imageView.mdk_width;
//    CGFloat imageHeight = button.imageView.mdk_height;
//
//
//
//    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleHeight/2 + interval/2), titleWidth/2, (titleHeight/2 + interval/2), -titleWidth/2);
//    button.titleEdgeInsets = UIEdgeInsetsMake((imageHeight/2 + interval/2), - imageWidth/2, -(imageHeight/2 + interval/2), imageWidth/2);

    
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;

    [button setImageEdgeInsets:UIEdgeInsetsMake(0,(titleSize.width)/2, titleSize.height + interval, -(titleSize.width)/2)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width)/2, 0, (imageSize.width)/2)];
    
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
}

/// 按钮设置 图片在右，文字在左
+ (void)setCustomAroundButton:(UIButton *)button image:(NSString *)imageStr title:(NSString *)title titleColor:(UIColor *)color titleFont:(CGFloat)font {
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(button.mdk_width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    
    CGFloat titleWidth = titleSize.width;
//    CGFloat titleHeight = titleSize.height;
    CGFloat imageWidth = button.imageView.mdk_width;
//    CGFloat imageHeight = button.imageView.mdk_height;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + 3, 0, -titleWidth - 3);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    
}
/// 按钮设置 带边框，非圆角
+ (void)setCustomBorderButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor title:(NSString *)title borderColor:(UIColor *)borderColor titleColor:(UIColor *)color titleFont:(CGFloat)font {
    
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.layer.borderColor = borderColor.CGColor;
    button.layer.borderWidth = 1.;
}

/// 按钮设置 带边框，圆角
+ (void)setCustomBorderCornerButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor title:(NSString *)title borderColor:(UIColor *)borderColor titleColor:(UIColor *)color titleFont:(CGFloat)font {
    
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.layer.cornerRadius = button.mdk_height / 2;
    button.layer.borderColor = borderColor.CGColor;
    button.layer.borderWidth = 1.;
}

/// 获得自定义按钮
+ (UIButton *)getCustomButton:(CGRect)customFram customTitle:(NSString *)customTitle customBgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor titleFont:(CGFloat)titleFont cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)selecter {
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = customFram;
    customButton.backgroundColor = bgColor;
    
    [customButton setTitle:customTitle forState:UIControlStateNormal];
    [customButton setTitleColor:titleColor forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    
    customButton.layer.cornerRadius = cornerRadius;
    [customButton addTarget:target action:selecter forControlEvents:UIControlEventTouchUpInside];
    
    return customButton;
}

/// 根据传入的文字、颜色、size、等获得富文本
+ (NSMutableAttributedString *)getAttributedString:(NSString *)str attriColor:(UIColor *)attriColor normalColr:(UIColor *)normalColor font:(CGFloat)attriFont attriSize:(NSInteger)attriSize {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSForegroundColorAttributeName value:attriColor range:NSMakeRange(0, attriSize)];
    [attrString addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(attriSize, str.length - attriSize)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attriFont] range:NSMakeRange(0, str.length)];
    
    
    return attrString;
}

/// 根据传入的文字、颜色、size、等获得富文本(改变文字颜色、字体)
+ (NSMutableAttributedString *)getAttributedString:(NSString *)str attriColor:(UIColor *)attriColor normalColr:(UIColor *)normalColor attriFont:(CGFloat)attriFont normalFont:(CGFloat)normalFont attriSize:(NSInteger)attriSize {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSForegroundColorAttributeName value:attriColor range:NSMakeRange(0, attriSize)];
    [attrString addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(attriSize, str.length - attriSize)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attriFont] range:NSMakeRange(0, attriSize)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:normalFont] range:NSMakeRange(attriSize, str.length - attriSize)];
    
    return attrString;
    
}

/// 给view添加通用的手势
+ (void)addNormalTapGesture:(UIView *)view target:(id)target action:(SEL)selection {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selection];
    [view addGestureRecognizer:tapGesture];
}

/// json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err)
    {
        MDK_FailureLog([NSString stringWithFormat:@"json解析失败：%@",err]);
        return nil;
    }
    return dic;
}

/// object转json
+ (NSString *)jsonStringWithObject:(id)object {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

/// float保留2位小数
+ (CGFloat)reserveDecimals:(CGFloat)floatNum {
    
    return (floorf(floatNum*100 + 0.5))/100;
}

/// 时间戳转时间
/// 获取当前时间戳
+ (NSString *)getCurrentStamp {
    
    NSDate *currentDate = [NSDate date];
    NSInteger currentStamp = (long)[currentDate timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%ld", currentStamp];
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSDateComponents *)getDateStringWithTimeStamp:(NSInteger)stamp {
    
    NSString *stamp_str = [NSString stringWithFormat:@"%ld", stamp];
    if (stamp_str.length == 13) {
        stamp = stamp/1000; //传入的时间戳str如果是精确到毫秒的记得要/1000
    }
    
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:stamp];
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:detailDate];
    
    return cmps;
    
}

/// 计算两个时间戳相差的时间（以时分秒展示）
+ (NSDateComponents *)getTimeInterval:(NSInteger)startStamp endTime:(NSInteger)endStamp {
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    
    NSString *startTime_str = [NSString stringWithFormat:@"%ld", startStamp];
    NSString *endTime_str = [NSString stringWithFormat:@"%ld", endStamp];
    
    //时间戳转时间
    if (startTime_str.length == 13) {
        startStamp = startStamp/1000;
    }
    if (endTime_str.length == 13) {
        endStamp = endStamp/1000;
    }
    
    //日期
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startStamp + delta];
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:endStamp + delta];
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    return cmps;
}

/// 计算传入的时间戳与当前时间差
+ (NSDateComponents *)getTimeInterval:(NSInteger)stamp {
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    
    NSDate *currentDate = [NSDate date];
    NSInteger currentStamp = (long)[currentDate timeIntervalSince1970];
    
    NSString *startTime_str = [NSString stringWithFormat:@"%ld", currentStamp];
    NSString *endTime_str = [NSString stringWithFormat:@"%ld", stamp];
    
    //时间戳转时间
    if (startTime_str.length == 13) {
        currentStamp = currentStamp/1000;
    }
    if (endTime_str.length == 13) {
        stamp = stamp/1000;
    }
    
    //日期
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:currentStamp + delta];
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:stamp + delta];
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    return cmps;
}

/// 时间转时间戳
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
    
}

/// 时间转NSDateComponents
+ (NSDateComponents *)getDateComponentsWithString:(NSString *)str {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:tempDate];
    
    return cmps;
}

/// 获取Caches目录路径
+ (NSString *)getCachesPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths lastObject];

    return cachesDir;
}

#pragma mark - 获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path {
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;
}

/// 比较传入的时间戳是否晚于当前时间
+ (BOOL)compareCurrentTime:(NSInteger)stamp {
    
    NSDate *currentDate = [NSDate date];
    NSInteger currentStamp = (long)[currentDate timeIntervalSince1970];
    
    NSString *startTime_str = [NSString stringWithFormat:@"%ld", currentStamp];
    NSString *endTime_str = [NSString stringWithFormat:@"%ld", stamp];
    
    //时间戳转时间
    if (startTime_str.length == 13) {
        currentStamp = currentStamp/1000;
    }
    if (endTime_str.length == 13) {
        stamp = stamp/1000;
    }
    
    if (stamp > currentStamp) {
        
        return YES;
    }
    
    return NO;
}



#pragma mark - 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path {
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
//            return NO;
        }
    }
    return YES;
}

/// 获取通用的MJRefreshNormalHeader
static NSString * CUSTOM_MJ_HEADER_IDLE_DES = @"继续下拉更新";
static NSString * CUSTOM_MJ_HEADER_PULLING_DES = @"释放更新";
static NSString * CUSTOM_MJ_HEADER_REFRESHING_DES = @"更新中...";
+ (MJRefreshNormalHeader *)getMJRefreshNormalHeaderWithTarget:(id)target action:(SEL)action {
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    
    [mj_header setTitle:CUSTOM_MJ_HEADER_IDLE_DES forState:MJRefreshStateIdle];
    [mj_header setTitle:CUSTOM_MJ_HEADER_PULLING_DES forState:MJRefreshStatePulling];
    [mj_header setTitle:CUSTOM_MJ_HEADER_REFRESHING_DES forState:MJRefreshStateRefreshing];
    
    mj_header.stateLabel.font = [UIFont systemFontOfSize:DETAIL_NORMAL_FONT_SIZE];
    mj_header.stateLabel.textColor = TEXT_BLACK_COLOR;
    
    return mj_header;
}

/// 获取通用的MJRefreshAutoNormalFooter
static NSString * CUSTOM_MJ_FOOTER_IDLE_DES = @"继续上拉加载更多";
static NSString * CUSTOM_MJ_FOOTER_REFRESHING_DES = @"加载中...";
static NSString * CUSTOM_MJ_FOOTER_NOMOREDATA_DES = @"没有更多数据啦";
+ (MJRefreshAutoNormalFooter *)getMJRefreshAutoNormalFooterWithTarget:(id)target action:(SEL)action {
    
    MJRefreshAutoNormalFooter *mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    
    mj_footer.triggerAutomaticallyRefreshPercent = 10.f;
    
    [mj_footer setTitle:CUSTOM_MJ_FOOTER_IDLE_DES forState:MJRefreshStateIdle];
    [mj_footer setTitle:CUSTOM_MJ_FOOTER_REFRESHING_DES forState:MJRefreshStateRefreshing];
    [mj_footer setTitle:CUSTOM_MJ_FOOTER_NOMOREDATA_DES forState:MJRefreshStateNoMoreData];
    
    mj_footer.stateLabel.font = [UIFont systemFontOfSize:DETAIL_NORMAL_FONT_SIZE];
    mj_footer.stateLabel.textColor = TEXT_BLACK_COLOR;
    
    return mj_footer;
}

/// 根据传入的nibname和frame获取view
+ (UIView *)getNibViewByNibName:(NSString *)nibName frame:(CGRect)frame {
    
    UIView *nibView;
    
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    NSArray *objs = [nib instantiateWithOwner:nil options:nil];
    nibView = objs[0];
    
    nibView.frame = frame;
    
    return nibView;
}

/// 给textfield添加监听
+ (void)addMonitorForTextField:(UITextField *)textField fieldChangeHandle:(FieldChangeHandle)fieldChangeHandle {
    
    [[self shareMDMethodManager] addMonitorForTextField:textField fieldChangeHandle:fieldChangeHandle];
}

- (void)addMonitorForTextField:(UITextField *)textField fieldChangeHandle:(FieldChangeHandle)fieldChangeHandle {
    
    [textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.fieldChangeHandle = fieldChangeHandle;
}

- (void)textFieldTextChange:(UITextField *)textField {
    
    self.fieldChangeHandle(textField.text);
}


//图片转data
/**
 * 压缩图片到指定文件大小
 *
 * @param image 目标图片
 * @param maxLength 目标大小（kb）
 *
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)maxLength {
    
    maxLength = maxLength * 1024;
    
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength){
        
        NSLog(@"初始图片符合尺寸，图片已经压缩成 %fKB",data.length/1024.0);
        return data;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
        
        NSLog(@"基本压缩后，图片已经压缩成 %fKB",data.length/1024.0);
        return data;
    }
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    NSLog(@"尺寸压缩后，图片已经压缩成 %fKB",data.length/1024.0);
    
    return data;
}


/*
 
 根据传入的字符串获取二维码图片
 
 */

//+ (UIImage *)getErCodeWithString:(NSString *)dataString {
//
//    // 1.创建滤镜
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    // 2.还原滤镜默认属性
//    [filter setDefaults];
//    // 3.设置需要生成二维码的数据到滤镜中
//    // OC中要求设置的是一个二进制数据
//    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//    [filter setValue:data forKeyPath:@"InputMessage"];
//    // 4.从滤镜从取出生成好的二维码图片
//    CIImage *ciImage = [filter outputImage];
//
//
//    return ciImage;
//}

//生成高清二维码
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight {
//    CGRect extentRect = CGRectIntegral(ciImage.extent);
//    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
//    // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extentRect) * scale;
//    size_t height = CGRectGetHeight(extentRect) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
//    // 保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
//    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
//    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
//    return [self imageBlackToTransparent:newImage withRed:200.0f andGreen:70.0f andBlue:189.0f];
//    
//}

/// 查看大图
+ (void)showDetailImage:(UIImage *)detailImage {
    
    if (detailImage == nil) {
        
        return;
    }
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    QMainDetailImageView *detailImgView = [[QMainDetailImageView alloc] initWithFrame:window.bounds];
    detailImgView.detailImage = detailImage;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.duration = 0.5;
    [detailImgView.layer addAnimation:transition forKey:nil];
    
    [window addSubview:detailImgView];
}

+ (void)showDetailImageWithURL:(NSString *)imgUrl {
    
    if (MDKStringIsEmpty(imgUrl)) {
        
        return;
    }
    
    UIImage *detailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    
    if (detailImage == nil) {
        
        return;
    }
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    QMainDetailImageView *detailImgView = [[QMainDetailImageView alloc] initWithFrame:window.bounds];
    detailImgView.detailImage = detailImage;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.duration = 0.5;
    [detailImgView.layer addAnimation:transition forKey:nil];
    
    [window addSubview:detailImgView];
}

/*
 
 * 传入数组、关键字(非必传，如果不传，则认为数组元素为字符串)，根据拼音排序，并返回一个浅排序数组（只是单纯排序），一个是深排序（排序，并按首字母分类）
 
 */
+ (NSArray *)getSortArrayByArray:(NSArray *)inpuArray keyword:(NSString *)keyword {
    
    NSArray *sortArray = inpuArray;
    
    if (MDKStringIsEmpty(keyword)) {
        
        sortArray = [sortArray sortedArrayUsingComparator:^(NSString *str1,NSString *str2) {
            
            if ([str1 localizedCompare:str2] == 1) {
                
                return NSOrderedDescending;
            } else {
                
                return NSOrderedAscending;
            }
            
        }];
        
        return sortArray;
        
    } else {
        
        sortArray = [sortArray sortedArrayUsingComparator:^(NSObject *dic1,NSObject *dic2) {
            
            NSDictionary *tempDic1;
            NSDictionary *tempDic2;
            if (![[dic1 class] isKindOfClass:[NSDictionary class]]) {
                
                tempDic1 = [self dicFromObject:dic1];
                tempDic2 = [self dicFromObject:dic2];
            } else {
                
                tempDic1 = (NSDictionary *)dic1;
                tempDic2 = (NSDictionary *)dic2;
            }
            
            if ([tempDic1[keyword] localizedCompare:tempDic2[keyword]] == 1) {
                
                return NSOrderedDescending;
            } else {
                
                return NSOrderedAscending;
            }
            
        }];
        
        return sortArray;
    }
    
}

/*
 
 * 传入数组、关键字(非必传，如果不传，则认为数组元素为字符串)，根据拼音排序，并返回一个深排序（排序，并按首字母分类）
 
 */
+ (NSArray *)getDeepSortArrayByArray:(NSArray *)inpuArray keyword:(NSString *)keyword {
    
    NSArray *sortArray = inpuArray;
    
    if (MDKStringIsEmpty(keyword)) {
        
        sortArray = [sortArray sortedArrayUsingComparator:^(NSString *str1,NSString *str2) {
            
            if ([str1 localizedCompare:str2] == 1) {
                
                return NSOrderedDescending;
            } else {
                
                return NSOrderedAscending;
            }
            
        }];
        
        NSMutableArray *deepSortArray = [NSMutableArray arrayWithCapacity:0];
        
        if (sortArray.count > 0) {
            
            NSString *currentFirstLetterStr = [self getFirstLetterFromString:[sortArray firstObject]];
            NSMutableDictionary *currentDic = [NSMutableDictionary dictionaryWithCapacity:0];
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i=0; i<sortArray.count; i++) {
                
                NSString *tempFirstLetterStr = [self getFirstLetterFromString:sortArray[i]];
                if ([currentFirstLetterStr isEqualToString:tempFirstLetterStr]) {
                    
                    [tempArray addObject:sortArray[i]];
                } else {
                    
                    [currentDic setObject:tempArray forKey:currentFirstLetterStr];
                    [deepSortArray addObject:currentDic];
                    
                    currentFirstLetterStr = tempFirstLetterStr;
                    currentDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    [tempArray removeAllObjects];
                    i--;
                }
                
            }
            
        }
        
        return deepSortArray;
        
    } else {
        
        sortArray = [sortArray sortedArrayUsingComparator:^(NSObject *dic1,NSObject *dic2) {
            
            NSDictionary *tempDic1;
            NSDictionary *tempDic2;
            if (![[dic1 class] isKindOfClass:[NSDictionary class]]) {
                
                tempDic1 = [self dicFromObject:dic1];
                tempDic2 = [self dicFromObject:dic2];
            } else {
                
                tempDic1 = (NSDictionary *)dic1;
                tempDic2 = (NSDictionary *)dic2;
            }
            
            if ([tempDic1[keyword] localizedCompare:tempDic2[keyword]] == 1) {
                
                return NSOrderedDescending;
            } else {
                
                return NSOrderedAscending;
            }
            
        }];
        
        NSMutableArray *deepSortArray = [NSMutableArray arrayWithCapacity:0];
        
        if (sortArray.count > 0) {
            
            NSString *currentFirstLetterStr = [self getFirstLetterFromString:[self dicFromObject:[sortArray firstObject]][keyword]];
            NSMutableDictionary *currentDic = [NSMutableDictionary dictionaryWithCapacity:0];
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i=0; i<sortArray.count; i++) {
                
                NSString *tempFirstLetterStr = [self getFirstLetterFromString:[self dicFromObject:sortArray[i]][keyword]];
                if ([currentFirstLetterStr isEqualToString:tempFirstLetterStr]) {
                    
                    [tempArray addObject:sortArray[i]];
                    if (i == sortArray.count - 1) {
                        [currentDic setObject:tempArray forKey:currentFirstLetterStr];
                        [deepSortArray addObject:currentDic];
                    }
                    
                } else {
                    
                    [currentDic setObject:tempArray forKey:currentFirstLetterStr];
                    [deepSortArray addObject:currentDic];
                    
                    currentFirstLetterStr = tempFirstLetterStr;
                    currentDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    tempArray = [NSMutableArray arrayWithCapacity:0];
                    i--;
                }
                
            }
            
        }
        
        return deepSortArray;
    }
    
}

//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *strPinYin = [str capitalizedString];
    //获取并返回首字母
    return [strPinYin substringToIndex:1];
}

//model转化为字典
+ (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}

//将可能存在model数组转化为普通数组
+ (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}

/// 彩色图片转换为黑白图片
+ (UIImage*)grayImage:(UIImage*)sourceImage {
    
    CGFloat image_width = sourceImage.size.width;
    CGFloat image_height = sourceImage.size.height;
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, image_width, image_height, 8., 0, colorSpace, kCGImageAlphaNone);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, image_width, image_height), sourceImage.CGImage);
    
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    return grayImage;
}

/// 修改图片颜色
+ (void)resetImageViewTintColorWithImageView:(UIImageView *)imageView image:(UIImage *)image tintcolor:(UIColor *)tintcoclor {
    
    if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
        imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    imageView.tintColor = tintcoclor;
    
}

/// 修改按钮图片颜色
+ (void)resetButtonImageViewTintColorWithImageView:(UIButton *)button image:(UIImage *)image tintcolor:(UIColor *)tintcoclor {
    
    if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
        [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    button.tintColor = tintcoclor;
    
}

/// 显示空白页面
+ (void)showEmptViewWithEmptImage:(NSString *)emptImage emptStr:(NSString *)emptStr superView:(UIView *)superView {
    
    QMainEmptView *emptView = (QMainEmptView *)[MDMethod getNibViewByNibName:@"QMainEmptView" frame:superView.bounds];
    emptView.emptImage = [UIImage imageNamed:emptImage];
    emptView.emptStr = emptStr;
    [superView addSubview:emptView];
}

/// 删除空白页面
+ (void)removeEmptViewFromSuperView:(UIView *)superView {
    
    for (id temp in superView.subviews) {
        
        if ([temp isKindOfClass:[QMainEmptView class]]) {
            
            [temp removeFromSuperview];
        }
    }
}

#pragma mark 我的足迹（操作数据库）
/// 添加一条数据到数据库表中
+ (void)addGoodsToTableWithGoodsId:(NSString *)goodsId goodsName:(NSString *)goodsName goodsLogo:(NSString *)goodsLogo goodsPrice:(NSString *)goodsPrice goodsSales:(NSString *)goodsSales success:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure {
    
    NSDate *currentDate = [NSDate date];
    NSInteger currentStamp = (long)[currentDate timeIntervalSince1970];
    
    NSDictionary *goodsInfo = @{
                                @"goodsId": goodsId,
                                @"goodsName": goodsName,
                                @"goodsLogo": goodsLogo,
                                @"goodsPrice": goodsPrice,
                                @"goodsSales": goodsSales,
                                @"browseTime": [NSString stringWithFormat:@"%ld", currentStamp]
                                };
    
    FMDatabase *db = [[MDFmdb shareTool] getDBWithDBName:Q_MAIN_DB_NAME];
    if (![[MDFmdb shareTool] DHisExistTable:Q_MAIN_GOODS_TABLE_NAME DataBase:db]) {
        //如果表不存在，则新建表并插入数据
        
        NSDictionary *keyTypes = @{
                                   @"goodsId": @"string",
                                   @"goodsName": @"string",
                                   @"goodsLogo": @"string",
                                   @"goodsPrice": @"string",
                                   @"goodsSales": @"string",
                                   @"browseTime": @"string"
                                   };
        
        [[MDFmdb shareTool] DataBase:db createTable:Q_MAIN_GOODS_TABLE_NAME keyTypes:keyTypes success:^{
           
            [[MDFmdb shareTool] DataBase:db insertKeyValues:goodsInfo intoTable:Q_MAIN_GOODS_TABLE_NAME success:^{
                
                success();
            } failure:failure];
        } failure:failure];
        
    } else {
        //如果表存在，则先判断这条数据是否存在
        
        if ([[MDFmdb shareTool] DHisExistObjectInDataBase:db fromTable:Q_MAIN_GOODS_TABLE_NAME colunm:@"goodsId" identify:goodsId]) {
            //如果数据存在，则先删除该数据，再重新添加
            
            //删除
            [[MDFmdb shareTool] deleteOneDataFormDatabase:db fromTable:Q_MAIN_GOODS_TABLE_NAME whereConditon:@{@"goodsId": goodsId}];
            
            //添加
            [[MDFmdb shareTool] DataBase:db insertKeyValues:goodsInfo intoTable:Q_MAIN_GOODS_TABLE_NAME success:^{
                
                success();
            } failure:failure];
        } else {
            //如果数据不存在，则直接添加
            
            [[MDFmdb shareTool] DataBase:db insertKeyValues:goodsInfo intoTable:Q_MAIN_GOODS_TABLE_NAME success:^{
                success();
            } failure:failure];
        }
    }
    
}

/// 取出数据
+ (void)getGoodsFromTableWithPage:(NSInteger)page success:(void (^)(NSArray *))success failure:(MDFmdbFailureHandler)failure {
    
    NSArray *goodsArray;
    
    FMDatabase *db = [[MDFmdbMethod shareTool] getDBWithDBName:Q_MAIN_DB_NAME];
    
    if (![[MDFmdb shareTool] DHisExistTable:Q_MAIN_GOODS_TABLE_NAME DataBase:db]) {
        //如果表不存在
        
        failure(CUSTOM_ERROR_CODE, @"您还没有浏览记录~");
    } else {
        //如果表存在，则先判断这条数据是否存在
        
        NSDictionary *keyTypes = @{
                                   @"goodsId": @"string",
                                   @"goodsName": @"string",
                                   @"goodsLogo": @"string",
                                   @"goodsPrice": @"string",
                                   @"goodsSales": @"string",
                                   @"browseTime": @"string"
                                   };
        
        goodsArray = [[MDFmdb shareTool] DataBase:db selectKeyTypes:keyTypes page:page count:MD_NORMAL_PAGESIZE fromTable:Q_MAIN_GOODS_TABLE_NAME];
        
        success(goodsArray);
    }
    
}

/// 删除所有数据
+ (void)deleteAllGoodsFromTableCompleteSuccess:(MDFmdbSuccessHandler)success failure:(MDFmdbFailureHandler)failure {
    
    FMDatabase *db = [[MDFmdbMethod shareTool] getDBWithDBName:Q_MAIN_DB_NAME];
    
    [[MDFmdb shareTool] dropTableFormDatabase:db table:Q_MAIN_GOODS_TABLE_NAME success:^{
        
        success();
    } failure:failure];
}

@end
