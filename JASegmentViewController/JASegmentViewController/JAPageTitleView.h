//
//  JAPageTitleView.h
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JAPageTitleView;

@protocol JAPageTitleViewDelegate <NSObject>

@optional
- (void)pageTitleView:(JAPageTitleView*)titleView didSelectIndex:(NSInteger)index;

@end

@interface JAPageTitleView : UIView

//主要的滚动视图
@property (nonatomic,strong) UIScrollView *scrollView;

//标题数组
@property (nonatomic,strong,readonly) NSArray *titleArray;

//label的宽度
@property (nonatomic,assign) CGFloat labelWidth;

//正常状态下label的字体颜色
@property (nonatomic,strong) UIColor *textNormalColor;

//选中状态下label的字体颜色
@property (nonatomic,strong) UIColor *textSelectColor;

//滑块的颜色
@property (nonatomic,strong) UIColor *scrollLineColor;

//选中的label的索引
@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,weak) id<JAPageTitleViewDelegate> delegate;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles needBottomLine:(BOOL)needBottomLine delegate:(id)delegate;

- (void)setTitleLabelWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end
