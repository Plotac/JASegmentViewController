//
//  ViewController.m
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import "ViewController.h"
#import "JASegmentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ViewController";
}

- (IBAction)jumpToSegmentVC:(UIButton *)sender {
    JASegmentViewController *segmentVC = [JASegmentViewController new];
    segmentVC.style = JASegmentViewControllerStyleAddTopView;
    [self.navigationController pushViewController:segmentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
