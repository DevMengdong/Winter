//
//  QMainPopUtil.m
//  POP
//
//  Created by 马德茂 on 2016/11/21.
//  Copyright © 2016年 PlutoMa. All rights reserved.
//

#import "QMainPopUtil.h"

@implementation QMainPopUtil
+ (void)pop_magnifyWithView:(UIView *)view beginRatio:(CGFloat)beginRatio endRatio:(CGFloat)endRatio completionBlock:(PopCompletionBlock)completionBlock {
    
    CGSize size = view.frame.size;
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    sizeAnimation.springSpeed = QMainPopSpringSpeed;
    sizeAnimation.springBounciness = QMainPopSpringBounciness;
    sizeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(size.width * beginRatio, size.height * beginRatio)];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(size.width * endRatio, size.height * endRatio)];
    if (completionBlock) {
        sizeAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [view pop_addAnimation:sizeAnimation forKey:@"pop_magnify"];
}

+ (void)pop_changePositionWithView:(UIView *)view beginPosition:(CGPoint)beginCenter endPosition:(CGPoint)endPosition completionBlock:(PopCompletionBlock)completionBlock {
    
    if (CGPointEqualToPoint(beginCenter, CGPointZero)) {
        beginCenter = view.center;
    }
    
    if (CGPointEqualToPoint(endPosition, CGPointZero)) {
        endPosition = view.center;
    }
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    positionAnimation.springSpeed = QMainPopSpringSpeed;
    positionAnimation.springBounciness = QMainPopSpringBounciness;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:beginCenter];
    positionAnimation.toValue = [NSValue valueWithCGPoint:endPosition];
    if (completionBlock) {
        positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [view pop_addAnimation:positionAnimation forKey:@"pop_position"];
}

+ (void)pop_changeFrameWithView:(UIView *)view beginFrame:(CGRect)beginFrame endFrame:(CGRect)endFrame completionBlock:(PopCompletionBlock)completionBlock {
    
    if (CGRectEqualToRect(beginFrame, CGRectZero)) {
        beginFrame = view.frame;
    }
    
    if (CGRectEqualToRect(endFrame, CGRectZero)) {
        endFrame = view.frame;
    }
    
    POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnimation.springSpeed = QMainPopSpringSpeed;
    frameAnimation.springBounciness = QMainPopSpringBounciness;
    frameAnimation.fromValue = [NSValue valueWithCGRect:beginFrame];
    frameAnimation.toValue = [NSValue valueWithCGRect:endFrame];
    if (completionBlock) {
        frameAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [view pop_addAnimation:frameAnimation forKey:@"pop_frame"];
}

+ (void)pop_changeCornerRadiusWithView:(nonnull UIView *)view beginCornerRadius:(CGFloat)beginCornerRadius endCornerRadius:(CGFloat)endCornerRadius completionBlock:(nullable PopCompletionBlock)completionBlock {
    
    POPSpringAnimation *cornerRadiusAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerRadiusAnimation.springSpeed = QMainPopSpringSpeed;
    cornerRadiusAnimation.springBounciness = QMainPopSpringBounciness;
    cornerRadiusAnimation.fromValue = @(beginCornerRadius);
    cornerRadiusAnimation.toValue = @(endCornerRadius);
    if (completionBlock) {
        cornerRadiusAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [view.layer pop_addAnimation:cornerRadiusAnimation forKey:@"pop_frame"];
}

+ (void)pop_changeAlphaWithView:(UIView *)view beginAlpha:(CGFloat)beginAlpha endAlpha:(CGFloat)endAlpha duration:(CFTimeInterval)duration completionBlock:(PopCompletionBlock)completionBlock {
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.duration = duration;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    alphaAnimation.fromValue = @(beginAlpha);
    alphaAnimation.toValue = @(endAlpha);
    if (completionBlock) {
        alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [view pop_addAnimation:alphaAnimation forKey:@"pop_alpha"];
}

+ (void)pop_changeBackgroundColorWithView:(UIView *)view beginColor:(UIColor *)beginColor endColor:(UIColor *)endColor duration:(CFTimeInterval)duration completionBlock:(PopCompletionBlock)completionBlock {
    
    if (!beginColor) {
        beginColor = view.backgroundColor;
    }
    if (!endColor) {
        endColor = view.backgroundColor;
    }
    
    POPBasicAnimation *backgroundColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    backgroundColorAnimation.duration = duration;
    backgroundColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    backgroundColorAnimation.fromValue = beginColor;
    backgroundColorAnimation.toValue = endColor;
    if (completionBlock) {
        backgroundColorAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [view pop_addAnimation:backgroundColorAnimation forKey:@"pop_alpha"];
}

+ (void)pop_changeConstentWithLayoutConstraint:(NSLayoutConstraint *)layoutConstraint beginConstent:(CGFloat)beginConstent endConstent:(CGFloat)endConstent completionBlock:(PopCompletionBlock)completionBlock {
    [layoutConstraint pop_removeAllAnimations];
    
    POPSpringAnimation *lcAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    lcAnimation.springSpeed = QMainPopSpringSpeed;
    lcAnimation.springBounciness = QMainPopSpringBounciness;
    lcAnimation.fromValue = @(beginConstent);
    lcAnimation.toValue = @(endConstent);
    if (completionBlock) {
        lcAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(anim);
            });
        };
    }
    
    [layoutConstraint pop_addAnimation:lcAnimation forKey:@"pop_layoutConstraint"];
}

+ (void)pop_changeConstantWithLayoutConstraints:(NSArray<QMainPopLayoutConstraint *> *)layoutConstraints completionBlock:(nullable void(^)(void))completionBlock {
    __block NSInteger count = 0;
    for (QMainPopLayoutConstraint *lc in layoutConstraints) {
        if (lc.layoutConstraint) {
            
            POPSpringAnimation *lcAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            lcAnimation.springSpeed = QMainPopSpringSpeed;
            lcAnimation.springBounciness = QMainPopSpringBounciness;
            lcAnimation.fromValue = @(lc.beginConstent);
            lcAnimation.toValue = @(lc.endConstent);
            lcAnimation.completionBlock = ^(POPAnimation *anim, BOOL isFinish) {
                count++;
                if (count >= layoutConstraints.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock();
                    });
                }
            };
            
            [lc.layoutConstraint pop_addAnimation:lcAnimation forKey:@"pop_layoutConstraint"];
        }
    }
}

@end
