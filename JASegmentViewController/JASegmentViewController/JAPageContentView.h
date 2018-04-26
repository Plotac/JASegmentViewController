//
//  JAPageContentView.h
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JAPageContentView;

@protocol JAPageContentViewDelegate <NSObject>

@optional
- (void)pageContentView:(JAPageContentView*)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

@interface JAPageContentView : UIView

@property (nonatomic,weak) id delegate;

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray<UIViewController*>*)childVCs parentVC:(UIViewController*)parentVC delegate:(id)delegate;

- (void)setContentViewCurrentIndex:(NSInteger)index;

@end
