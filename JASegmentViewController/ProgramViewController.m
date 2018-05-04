//
//  ProgramViewController.m
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import "ProgramViewController.h"

@interface ProgramViewController ()

@end

@implementation ProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(100, 100, 200, 100);
    label.text = @"ProgramViewController";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
