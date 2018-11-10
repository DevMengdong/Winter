//
//  MDDetailImageView.m
//  QMainProject
//
//  Created by 李孟东 on 2018/10/8.
//  Copyright © 2018年 dareway. All rights reserved.
//

#import "MDDetailImageView.h"
#import "QMainPopUtil.h"

@interface MDDetailImageView() {
    
    CGFloat _lastScare;
    CGFloat _firstX;
    CGFloat _firstY;
    CGAffineTransform _transform;
    CGRect _imgFrame;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *detailImageView;

@end

@implementation MDDetailImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        self.windowLevel = UIWindowLevelAlert;
        
        self.bgView.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)setDetailImage:(UIImage *)detailImage {
    _detailImage = detailImage;
    
    CGFloat scale = _detailImage.size.width / self.frame.size.width;
    CGFloat height = _detailImage.size.height / scale;
    
    self.detailImageView.frame = CGRectMake(0, (self.frame.size.height - height)/2, self.frame.size.width, height);
    self.detailImageView.image = _detailImage;
    
    _transform = self.detailImageView.transform;
    _imgFrame = self.detailImageView.frame;
    
}

#pragma mark ----- 懒加载
- (UIView *)bgView {
 
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgView];
    }
    
    return _bgView;
}

- (UIImageView *)detailImageView {
    
    if (_detailImageView == nil) {
        
        _detailImageView = [[UIImageView alloc] init];
        _detailImageView.userInteractionEnabled = YES;
        [self addSubview:_detailImageView];
        
        //单击隐藏
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1;
        [_detailImageView addGestureRecognizer:singleRecognizer];
        
        //放大
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchChangeScale:)];
        [_detailImageView addGestureRecognizer:pinchGesture];
        
        //拖动
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [_detailImageView addGestureRecognizer:panGesture];
        
        //双击恢复
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResolve:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [_detailImageView addGestureRecognizer:doubleTapGesture];
        
        [singleRecognizer requireGestureRecognizerToFail:doubleTapGesture];
    }
    
    return _detailImageView;
}

#pragma mark action

//单击隐藏
- (void)handleSingleTapFrom {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
       
        [self removeFromSuperview];
    }];
}

//放大
- (void)pinchChangeScale:(UIPinchGestureRecognizer *)pinch {
    
    UIImageView *imageView = (UIImageView *)pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan) {
        _lastScare = 1.0;
        
    }
    CGFloat scare = 1 - (_lastScare - pinch.scale);
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scare, scare);
    [imageView setTransform:newTransform];
    _lastScare = pinch.scale;
}

//拖动
- (void)move:(UIPanGestureRecognizer *)pan {
    
    CGPoint transpoint = [pan translationInView:self];
    UIImageView *imageView = (UIImageView *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        _firstX = imageView.center.x;
        _firstY = imageView.center.y;
        
    }
    if (_lastScare == 1.0f) {
        return;
        
    }
    transpoint = CGPointMake(_firstX+transpoint.x, _firstY+transpoint.y);
    [imageView setCenter:transpoint];
    
}

//双击恢复
- (void)tapResolve:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    [imageView setTransform:_transform];
    [imageView setFrame:_imgFrame];
    _lastScare = 1.0f;
}

#pragma mark method

- (void)show {
    
    [QMainPopUtil pop_changeAlphaWithView:self beginAlpha:0. endAlpha:1. duration:0.2 completionBlock:^(POPAnimation *anim) {
       
        self.alpha = 1.;
    }];
    
    [self makeKeyAndVisible];
}


@end
