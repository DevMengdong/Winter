//
//  ViewController.m
//  Winter
//
//  Created by 李孟东 on 2018/11/1.
//  Copyright © 2018 DevMengdong. All rights reserved.
//

#import "ViewController.h"
#import "Winter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [MDMethod showDetailImageWithUrl:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2168427908,4072089613&fm=200&gp=0.jpg"];
//    [MDMethod alertWithTitle:@"123" content:@"222" cancelButton:@"22" otherButtons:@[@"333"] style:QMainAlertViewStyleSuccess parameters:nil alertHandle:^(NSInteger selectIndex) {
//        
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
