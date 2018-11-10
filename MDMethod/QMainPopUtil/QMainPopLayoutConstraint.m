//
//  QMainPopLayoutConstraint.m
//  POP
//
//  Created by 马德茂 on 2016/11/21.
//  Copyright © 2016年 PlutoMa. All rights reserved.
//

#import "QMainPopLayoutConstraint.h"

@implementation QMainPopLayoutConstraint

+ (instancetype)layoutConstraint:(NSLayoutConstraint *)layoutConstraint beginConstent:(CGFloat)beginConstent endConstent:(CGFloat)endConstent {
    QMainPopLayoutConstraint *lc = [[QMainPopLayoutConstraint alloc] init];
    lc.layoutConstraint = layoutConstraint;
    lc.beginConstent = beginConstent;
    lc.endConstent = endConstent;
    return lc;
}

@end
