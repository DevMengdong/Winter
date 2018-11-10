//
//  QMainPopLayoutConstraint.h
//  POP
//
//  Created by 马德茂 on 2016/11/21.
//  Copyright © 2016年 PlutoMa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>

typedef void(^PopCompletionBlock)(POPAnimation *anim);

@interface QMainPopLayoutConstraint : NSObject
@property (nonatomic, strong) NSLayoutConstraint *layoutConstraint;
@property (nonatomic, assign) CGFloat beginConstent;
@property (nonatomic, assign) CGFloat endConstent;

+ (instancetype)layoutConstraint:(NSLayoutConstraint *)layoutConstraint beginConstent:(CGFloat)beginConstent endConstent:(CGFloat)endConstent;
@end
