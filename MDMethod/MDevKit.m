//
//  MDevKit.m
//
//  Created by Marshall on 2017/10/18.
//  Copyright © 2017年 Marshall. All rights reserved.
//

#import "MDevKit.h"

@implementation MDevKit

@end

#pragma mark - Extension For UIView
@implementation UIView (MDevKit)
- (CGFloat)mdk_width { return self.bounds.size.width; }
- (CGFloat)mdk_height { return self.bounds.size.height; }
- (CGFloat)mdk_minX { return self.frame.origin.x; }
- (CGFloat)mdk_minY { return self.frame.origin.y; }
- (CGFloat)mdk_midX { return self.frame.origin.x + self.mdk_width/2.0; }
- (CGFloat)mdk_midY { return self.frame.origin.y + self.mdk_height/2.0; }
- (CGFloat)mdk_maxX { return self.mdk_width + self.mdk_minX; }
- (CGFloat)mdk_maxY { return self.mdk_height + self.mdk_minY; }
- (CGPoint)mdk_origin { return self.frame.origin; }
- (CGSize)mdk_size { return self.frame.size; }
@end

#pragma mark - Params

NSString* MDK_CheckParam(NSString* object) {
    if (MDKStringIsEmpty(object)) {
        return @"";
    }
    return object;
}

NSString* MDK_NumberToString(NSNumber *number) {
    if (number == nil) {
        return @"0";
    } else {
        return [number stringValue];
    }
}

#pragma mark - Color With Hex String
UIColor* MDK_ColorWithHex(NSString *hexStr, CGFloat alpha) {
    if ([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSString *cString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

#pragma mark - GCD
void MDK_asyncWithMainThread(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}
void MDK_syncWithMainThread(dispatch_block_t block) {
    dispatch_sync(dispatch_get_main_queue(), block);
}
void MDK_asyncAfter(double time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
void MDK_asyncWithGlobaQueue(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, 0), block);
}
void MDK_syncWithGlobaQueue(dispatch_block_t block) {
    dispatch_sync(dispatch_get_global_queue(0, 0), block);
}

#pragma mark - Log
void MDK_NetworkLog(NSString *str) {
    const char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
    printf("▶️▶️▶️ - %s\n", s);
}

void MDK_SuccessLog(NSString *str) {
    const char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
    printf("✅ - %s\n", s);
}
void MDK_FailureLog(NSString *str) {
    printf("❌ - %s\n", [str cStringUsingEncoding:NSUTF8StringEncoding]);
}
void MDK_WarningLog(NSString *str) {
    printf("⚠️ - %s\n", [str cStringUsingEncoding:NSUTF8StringEncoding]);
}

void MDK_Convention(NSString *str) {
    printf("🔆 - %s\n", [str cStringUsingEncoding:NSUTF8StringEncoding]);
}

#pragma mark - Font
@implementation UIFont (adapt)
@end

@implementation UITableView (CellRegister)
- (void)mdk_registerCellNibWith:(id)cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)mdk_registerCellClassWith:(id)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}
@end

@implementation UICollectionView (CellRegister)
- (void)mdk_registerCellNibWith:(id)cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)mdk_registerCellClassWith:(id)cellClass {
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}
@end
