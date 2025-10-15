//
//  CNICloudDocumentPickerViewController.m
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/12.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import "CNICloudDocumentPickerController.h"

@interface CNICloudDocumentPickerController (){
    UIColor *_defultColor;
}

@end

@implementation CNICloudDocumentPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.themeColor) {
        _defultColor = [UITabBar appearance].tintColor;
        [self configuraThemeColor:self.themeColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_defultColor) {
        [self configuraThemeColor:_defultColor];
    }
    
}

/** 设置主题颜色 */
- (void)configuraThemeColor:(UIColor *)themeColor {
    [UIImageView appearance].tintColor = themeColor;
    [UITabBar appearance].tintColor = themeColor;
    [UIView appearanceWhenContainedInInstancesOfClasses:UIAlertController.self];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: themeColor} forState:UIControlStateNormal];
    [UILabel appearance].tintColor = themeColor;
    [UIButton appearance].tintColor = themeColor;
    self.view.tintColor = themeColor;
}


@end
