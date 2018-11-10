//
//  QMainAlertView.m
//  QMain
//
//  Created by SongZhe on 16/6/6.
//  Copyright © 2016年 dareway. All rights reserved.
//

#import "QMainAlertView.h"
#import "MDMethod.h"
#import "Masonry.h"
#import "QMainAlertViewStyleKit.h"
#import "QMainPopUtil.h"

#define kButtonHeight 40
#define kPadding 8
#define kTitleHeight 35

#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface QMainAlertView()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UILabel *titleLabel;
@property NSInteger buttonIndex;
@property (nonatomic,strong) UITextView *contentTextView;
@property (strong,nonatomic)UIView *circleViewBackground;
@property (strong,nonatomic)UIView *circleIconBgView;
@property (strong,nonatomic)UIImageView *circleIconImageView;
@end

@implementation QMainAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = UIWindowLevelAlert;

        [self addSubview:self.bgView];
        
    }
    
    return self;
}

- (void)setAlertWithTitle:(NSString *)titleText andContent:(NSString *)content andCancelButton:(NSString *)cancelButtonText andOtherButtons:(NSArray *)otherButtonArray style:(QMainAlertViewStyle)style parameters:(NSDictionary *)params alertHandle:(QMainAlertHandle)alertHandle {
    
    CGRect contentRect = [content boundingRectWithSize:CGSizeMake(self.bounds.size.width*.7 - 8 * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil];
    CGFloat contentHeight = contentRect.size.height;
    contentHeight += 30 +15 +60;
    if(titleText != nil){
        contentHeight += 43;
    }
    if(contentHeight >= 350) {
        
        self.bgView.frame = CGRectMake(0, 0, self.bounds.size.width*.7, 350);
    } else if (contentHeight <= 150) {
        
        self.bgView.frame = CGRectMake(0, 0, self.bounds.size.width*.7, 150);
    } else {
        
        self.bgView.frame = CGRectMake(0, 0, self.bounds.size.width*.7, contentHeight);
    }
    
    self.bgView.center = self.center;
    
    [self.circleViewBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView.mas_top);
        make.height.width.equalTo(@60);
    }];
    
    [self.circleIconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.circleViewBackground);
        make.height.width.equalTo(@55);
    }];
    
    self.circleIconImageView  = [UIImageView new];
    [self.circleIconBgView addSubview:self.circleIconImageView];
    [self.circleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.circleViewBackground);
        make.height.width.equalTo(@25);
    }];
    
    self.buttonIndex = 0;
    self.buttonArray = [[NSMutableArray alloc] init];
    
    [self.cancelButton setTitle:cancelButtonText forState:UIControlStateNormal];
    [self.buttonArray addObject:self.cancelButton];
    
    self.buttonIndex++;
    
    [self addButton:otherButtonArray];
    
    //将button添加到alertview上
    [self addButtonToAlert];
    
    //title
    [self.titleLabel setText:titleText];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        if(titleText == nil){
            make.height.equalTo(@1);
            make.top.equalTo(self.circleViewBackground.mas_bottom).offset(0);
        }else{
            make.top.equalTo(self.circleViewBackground.mas_bottom).offset(6);
            make.height.equalTo(@(30));
        }
    }];
    
    //content
    [self.contentTextView setText:MDMethodCheckString(content)];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kPadding);
        make.left.equalTo(self.bgView.mas_left).offset(kPadding);
        make.right.equalTo(self.bgView.mas_right).offset(-kPadding);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-kPadding);
    }];
    
    self.alertHandle = alertHandle;
    
    [self setAlertStyle:style parameters:params];
}

#pragma mark  懒加载
- (UIView *)bgView {
    
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.center = self.center;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
//        _bgView.layer.borderColor = [UIColor colorWithRed:229./255. green:229./255. blue:229./255. alpha:1.].CGColor;
//        _bgView.layer.borderWidth = 0.5;
    }
    
    return _bgView;
}

- (UIView *)circleViewBackground {
    
    if (_circleViewBackground == nil) {
        
        _circleViewBackground  = [UIView new];
        _circleViewBackground.backgroundColor = [UIColor whiteColor];
        _circleViewBackground.layer.cornerRadius = 60./2;
        [self addSubview:_circleViewBackground];
    }
    
    return _circleViewBackground;
}

- (UIView *)circleIconBgView {
    
    if (_circleIconBgView == nil) {
        
        _circleIconBgView  = [UIView new];
        _circleIconBgView.layer.cornerRadius = 55./2;
        [self.circleViewBackground addSubview:_circleIconBgView];
    }
    
    return _circleIconBgView;
}

- (UIButton *)cancelButton {
    
    if (_cancelButton == nil) {
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.masksToBounds = YES;
        
        [_cancelButton addTarget:self action:@selector(buttonActionAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20.f]];
        
        [self.bgView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UITextView *)contentTextView {
    
    if (_contentTextView == nil) {
        
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        _contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentTextView setFont:[UIFont systemFontOfSize:16]];
        _contentTextView.editable = NO;
        [self.bgView addSubview:_contentTextView];
    }
    
    return _contentTextView;
}

#pragma mark action
- (void)buttonActionAtIndex:(id)sender{
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        
        UIButton *button = [self.buttonArray objectAtIndex:i];
        if (sender == button) {
            
            [QMainPopUtil pop_changeAlphaWithView:self beginAlpha:1. endAlpha:0.3 duration:0.2 completionBlock:^(POPAnimation *anim) {
                
                [self dismiss];
                self.alertHandle(i);
            }];
            return;
        }
    }
}

#pragma mark method

///添加button
- (void)addButton:(NSArray *)buttonArray {
    
    for (NSString *buttonTitle in buttonArray) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        button.layer.cornerRadius = 5;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button addTarget:self action:@selector(buttonActionAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
    }
}

//将button添加到alertView上
- (void)addButtonToAlert {
    
    for (UIButton *button in self.buttonArray) {
        [self.bgView addSubview:button];
        [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
        [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:kButtonHeight]];
    }
    UIButton *firstButton = [self.buttonArray firstObject];
    [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:firstButton attribute:NSLayoutAttributeLeading multiplier:1 constant:-10]];
    UIButton *lastButton = [self.buttonArray lastObject];
    [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    for (int i = 1; i < self.buttonArray.count; i++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        UIButton *prevButton = [self.buttonArray objectAtIndex:(i-1)];
        [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:prevButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
        [self.bgView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:prevButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }
}

- (void)setAlertStyle:(QMainAlertViewStyle)style parameters:(NSDictionary *)params {
    
    // Alert color/icon
    UIColor *viewColor;
    UIImage *iconImage;
    
    // Icon style
    switch (style)
    {
        case QMainAlertViewStyleSuccess:
            viewColor = UIColorFromHEX(0x22B573);
            iconImage = QMainAlertViewStyleKit.imageOfCheckmark;
            break;
            
        case QMainAlertViewStyleError:
            viewColor = UIColorFromHEX(0xC1272D);
            iconImage = QMainAlertViewStyleKit.imageOfCross;
            break;
            
        case QMainAlertViewStyleNotice:
            viewColor = UIColorFromHEX(0x727375);
            iconImage = QMainAlertViewStyleKit.imageOfNotice;
            break;
            
        case QMainAlertViewStyleWarning:
            viewColor = UIColorFromHEX(0xFFD110);
            iconImage = QMainAlertViewStyleKit.imageOfWarning;
            break;
            
        case QMainAlertViewStyleInfo:
            viewColor = UIColorFromHEX(0x2866BF);
            iconImage = QMainAlertViewStyleKit.imageOfInfo;
            break;
            
        case QMainAlertViewStyleEdit:
            viewColor = UIColorFromHEX(0xA429FF);
            iconImage = QMainAlertViewStyleKit.imageOfEdit;
            break;
            
        case QMainAlertViewStyleWaiting:
            viewColor = UIColorFromHEX(0x6c125d);
            break;
            
        case QMainAlertViewStyleQuestion:
            viewColor = UIColorFromHEX(0x727375);
            iconImage = QMainAlertViewStyleKit.imageOfQuestion;
            break;
            
        case QMainAlertViewStyleCustom:
            //预留
            break;
    }
    self.circleIconImageView.image = iconImage;
    self.circleIconBgView.backgroundColor = viewColor;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        btn.backgroundColor = viewColor;
    }];
    
}

- (void)show {
    
    [QMainPopUtil pop_changeAlphaWithView:self beginAlpha:0.3 endAlpha:1. duration:0.2 completionBlock:^(POPAnimation *anim) {
        
        self.alpha = 1.;
    }];
    
    [self makeKeyAndVisible];
}

- (void)dismiss {
    [self resignKeyWindow];
    self.hidden = YES;
}

@end
