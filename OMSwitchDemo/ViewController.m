//
//  ViewController.m
//  OMSwitchDemo
//
//  Created by kehwa on 16/7/13.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ViewController.h"
#import "OMSwitch.h"
@interface ViewController ()
@property (nonatomic , strong)OMSwitch *userSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.userSwitch];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.userSwitch.frame = CGRectMake(10, 80, 50, 30);
    
}

- (OMSwitch *)userSwitch{
    if (_userSwitch == nil) {
        _userSwitch = [[OMSwitch alloc]init];
        _userSwitch.selectedText = @"弹幕";
        _userSwitch.unselectedText = @"弹幕";
    }
    return _userSwitch;
}


@end
