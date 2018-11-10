//
//  QMainPopUtil.h
//  POP
//
//  Created by 马德茂 on 2016/11/21.
//  Copyright © 2016年 PlutoMa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>
#import "QMainPopLayoutConstraint.h"

#define QMainPopSpringSpeed (10)
#define QMainPopSpringBounciness (6)
#define QMainPopBasicDuration (0.75)


@interface QMainPopUtil : NSObject
/**
 *  放大显示，需指定初始比例和最终比例
 */
+ (void)pop_magnifyWithView:(nonnull UIView *)view beginRatio:(CGFloat)beginRatio endRatio:(CGFloat)endRatio completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  提供center来改变位置，需指定初始位置和最终位置，若指定为CGPointZero，默认为当前位置
 */
+ (void)pop_changePositionWithView:(nonnull UIView *)view beginPosition:(CGPoint)beginCenter endPosition:(CGPoint)endPosition completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  提供frame来改变位置及大小，需要指定初始frame和最终frame，若指定为CGRectZero，默认为当前frame
 */
+ (void)pop_changeFrameWithView:(nonnull UIView *)view beginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  改变CornerRadius，需指定初始CornerRadius和最终CornerRadius
 */
+ (void)pop_changeCornerRadiusWithView:(nonnull UIView *)view beginCornerRadius:(CGFloat)beginCornerRadius endCornerRadius:(CGFloat)endCornerRadius completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  改变透明度，需要指定初始透明度和最终透明度
 */
+ (void)pop_changeAlphaWithView:(nonnull UIView *)view beginAlpha:(CGFloat)beginAlpha endAlpha:(CGFloat)endAlpha duration:(CFTimeInterval)duration completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  改变背景色，需要指定初始颜色和最终颜色，若不指定，默认为当前颜色
 */
+ (void)pop_changeBackgroundColorWithView:(nonnull UIView *)view beginColor:(nullable UIColor *)beginColor endColor:(nullable UIColor *)endColor duration:(CFTimeInterval)duration completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  改变一个NSLayoutConstraint
 */
+ (void)pop_changeConstentWithLayoutConstraint:(nonnull NSLayoutConstraint *)layoutConstraint beginConstent:(CGFloat)beginConstent endConstent:(CGFloat)endConstent completionBlock:(nullable PopCompletionBlock)completionBlock;

/**
 *  改变一组NSLayoutConstraint
 */
+ (void)pop_changeConstantWithLayoutConstraints:(nullable NSArray<QMainPopLayoutConstraint *>*)layoutConstraints completionBlock:(nullable void(^)(void))completionBlock;
@end
