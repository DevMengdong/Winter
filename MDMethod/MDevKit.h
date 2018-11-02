//
//  MDevKit.h
//
//  Created by Marshall on 2017/10/18.
//  Copyright © 2017年 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - LOG
#define MDKLog(FORMAT, ...) fprintf(stderr, "%s 😊 Line %d 😊 %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#pragma mark - QUICK WEAK
#define MDKWeakSelf(type)  __weak typeof(type) weak##type = type;
#define MDKStrongSelf(type)  __strong typeof(type) type = weak##type;

#pragma mark - QUICK UIColor
#define MDKClearColor [UIColor clearColor]
#define MDKWhiteColor [UIColor whiteColor]
#define MDKBlackColor [UIColor blackColor]
#define MDKRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#pragma mark - Check Phone Type
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhone5_SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
#define iPhoneNotPlus [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
#define iPhonePlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
#define iPhoneX [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f

#pragma mark - Object Check
#define MDKStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define MDKArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define MDKDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)
#define MDKObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selectror(count)] && [(NSArray *)_object count] == 0))

#pragma mark - Screen
#define MDKScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define MDKScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define MDKScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)
#define MDKWidthScale MDKScreenWidth / 1080.0f
#define MDKHeightScale MDKScreenHeight / 1920.0f
#define MDKGetFontOfSize(value) [UIFont systemFontOfSize:value / MDKWidthScale]

#pragma mark - Other
#define MDKApplication        [UIApplication sharedApplication]
#define MDKAppDelegate        [UIApplication sharedApplication].delegate
#define MDKKeyWindow          [UIApplication sharedApplication].delegate.keyWindow
#define MDKUserDefaults       [NSUserDefaults standardUserDefaults]
#define MDKNotificationCenter [NSNotificationCenter defaultCenter]
#define MDKMainBundle         [NSBundle mainBundle]
#define MDKStatusBarFrame     [UIApplication sharedApplication].statusBarFrame

#define MDKAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MDKSystemVersion [[UIDevice currentDevice] systemVersion]
#define MDKCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define MDKDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define MDKTempPath NSTemporaryDirectory()
#define MDKCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


#pragma mark - Notification
#define MDKPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];


@interface MDevKit : NSObject

@end

#pragma mark - Extension For UIView

@interface UIView (MDevKit)
@property (nonatomic, assign, readonly) CGFloat mdk_width;
@property (nonatomic, assign, readonly) CGFloat mdk_height;
@property (nonatomic, assign, readonly) CGFloat mdk_minX;
@property (nonatomic, assign, readonly) CGFloat mdk_minY;
@property (nonatomic, assign, readonly) CGFloat mdk_maxX;
@property (nonatomic, assign, readonly) CGFloat mdk_maxY;
@property (nonatomic, assign, readonly) CGFloat mdk_midX;
@property (nonatomic, assign, readonly) CGFloat mdk_midY;
@property (nonatomic, assign, readonly) CGPoint mdk_origin;
@property (nonatomic, assign, readonly) CGSize mdk_size;
@end

NSString* MDK_CheckParam(NSString* object);
NSString* MDK_NumberToString(NSNumber *number);

#pragma mark - Color With Hex String
UIColor* MDK_ColorWithHex(NSString *hexStr, CGFloat alpha);

#pragma mark - GCD
void MDK_asyncWithMainThread(dispatch_block_t block);
void MDK_syncWithMainThread(dispatch_block_t block);
void MDK_asyncAfter(double time, dispatch_block_t block);
void MDK_asyncWithGlobaQueue(dispatch_block_t block);
void MDK_syncWithGlobaQueue(dispatch_block_t block);

#pragma mark - Log
void MDK_NetworkLog(NSString *str);
void MDK_SuccessLog(NSString *str);
void MDK_FailureLog(NSString *str);
void MDK_WarningLog(NSString *str);
void MDK_Convention(NSString *str);

#pragma mark - Font
@interface UIFont (adapt)
@end

#pragma mark - UITableView
@interface UITableView (CellRegister)
- (void)mdk_registerCellNibWith:(id)cellClass;
- (void)mdk_registerCellClassWith:(id)cellClass;
@end

@interface UICollectionView (CellRegister)
- (void)mdk_registerCellNibWith:(id)cellClass;
- (void)mdk_registerCellClassWith:(id)cellClass;
@end
