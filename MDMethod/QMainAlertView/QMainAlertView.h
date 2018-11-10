//
//  QMainAlertView.h
//  QMain
//
//  Created by SongZhe on 16/6/6.
//  Copyright © 2016年 dareway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMainAlertView;

typedef void(^QMainAlertHandle)(NSInteger selectIndex);

typedef NS_ENUM(NSInteger, QMainAlertViewStyle)
{
    QMainAlertViewStyleSuccess,//成功
    QMainAlertViewStyleError,//错误
    QMainAlertViewStyleNotice,//注意
    QMainAlertViewStyleWarning,//警告
    QMainAlertViewStyleInfo,//信息
    QMainAlertViewStyleEdit,//编辑
    QMainAlertViewStyleWaiting,//等待
    QMainAlertViewStyleQuestion,//问题
    QMainAlertViewStyleCustom//自定义
};

@interface QMainAlertView : UIWindow

/**
 显示某种样式的AlertView
 @param titleText           标题
 @param content             内容
 @param cancelButtonText    取消按钮
 @param otherButtonArray    其他q按钮
 @param style               样式类型
 @param params              预留参数，为空传nil
 */
-(void)setAlertWithTitle:(NSString *)titleText andContent:(NSString *)content andCancelButton:(NSString *)cancelButtonText andOtherButtons:(NSArray*)otherButtonArray style:(QMainAlertViewStyle)style parameters:(NSDictionary *)params alertHandle:(QMainAlertHandle)alertHandle;

///block回调
@property (nonatomic, copy) QMainAlertHandle alertHandle;

///展示
- (void)show;
///隐藏
- (void)dismiss;

@end
