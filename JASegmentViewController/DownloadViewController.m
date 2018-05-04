//
//  DownloadViewController.m
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label = [UILabel new];
    _label.frame = CGRectMake(100, 100, 300, 100);
    [self.view addSubview:_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
