//
//  JASegmentViewController.h
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JASegmentViewControllerStyle) {
    JASegmentViewControllerStyleDefault = 0,
    JASegmentViewControllerStyleAddTopView
};

@interface JASegmentViewController : UIViewController

@property (nonatomic,assign) JASegmentViewControllerStyle style;

@end
