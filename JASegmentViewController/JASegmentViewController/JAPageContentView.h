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

//是否完全滑过去
@property (nonatomic,assign) BOOL scrollCovered;

@property (nonatomic,weak) id delegate;

/* 初始化方法
 *
 * frame             视图的位置大小
 * childVCs          子控制器数组
 * parentVC          父控制器
 * defaultIndex      默认移动到第几个index(必须与JAPageTitleView设置的相对应)
 * delegate          代理
 *
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray<UIViewController*>*)childVCs parentVC:(UIViewController*)parentVC defaultIndex:(NSInteger)defaultIndex delegate:(id)delegate;

//设置该View移动到第几个index
- (void)setContentViewCurrentIndex:(NSInteger)index;

@end
