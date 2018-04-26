//
//  JAPageTitleView.m
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import "JAPageTitleView.h"

// UI常量
static CGFloat const kScrollLineH = 2;

// Define
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface JAPageTitleView ()

//标题数组
@property (nonatomic,strong) NSArray *titles;

//标题字体
@property (nonatomic,strong) UIFont *titleFont;

//当前索引
@property (nonatomic,assign) NSInteger currentIndex;

//主要的滚动视图
@property (nonatomic,strong) UIScrollView *scrollView;

//滚动的选中条
@property (nonatomic,strong) UIView *scrollLine;

//是否需要底部横线
@property (nonatomic,assign) BOOL needBottomLine;

//标题数组
@property (nonatomic,strong) NSMutableArray *titleLabs;

@end

@implementation JAPageTitleView

#pragma mark - 初始化方法 & UI
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles needBottomLine:(BOOL)needBottomLine delegate:(id<JAPageTitleViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabs = [[NSMutableArray alloc]init];
        
        //默认值
        self.titles = titles;
        self.needBottomLine = needBottomLine;
        self.delegate = delegate;
        self.titleFont = [UIFont systemFontOfSize:16.0f];
        self.textNormalColor = [UIColor blackColor];
        self.textSelectColor = [self colorWithHexStr:@"#5587e6"];
        self.scrollLineColor = [self colorWithHexStr:@"#5587e6"];
        _currentIndex = self.selectIndex ? self.selectIndex : 1;//默认选择第2个label
        
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    CGFloat labWidth = self.labelWidth ? self.labelWidth : self.frame.size.width / self.titles.count;
    for (NSInteger i=0; i<self.titles.count; i++) {
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(i * labWidth, 0, labWidth, self.frame.size.height - kScrollLineH)];
        titleLab.font = self.titleFont;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = self.textNormalColor;
        titleLab.tag = i;
        titleLab.text = [self.titles objectAtIndex:i];
        titleLab.userInteractionEnabled = YES;
        [_scrollView addSubview:titleLab];
        [self.titleLabs addObject:titleLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)];
        [titleLab addGestureRecognizer:tap];
    }
    
    UILabel *currentLab = [self.titleLabs objectAtIndex:_currentIndex];
    currentLab.textColor = self.textSelectColor;
    
    //滑块
    _scrollLine = [[UIView alloc]initWithFrame:CGRectMake(_currentIndex * self.frame.size.width / self.titles.count, self.frame.size.height - kScrollLineH - 1, labWidth, kScrollLineH)];
    _scrollLine.backgroundColor = self.scrollLineColor;
    [_scrollView addSubview:_scrollLine];
    
    //底部分割线
    if (self.needBottomLine) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, [[UIScreen mainScreen]bounds].size.width, 1)];
        lineView.backgroundColor = [self colorWithHexStr:@"#e5e5e5e"];
        [_scrollView addSubview:lineView];
    }
}

#pragma mark - 视图点击事件
- (void)labelClick:(UITapGestureRecognizer*)tap {
    
    //1.拿到点击之后的当前label
    UILabel *currentLab = nil;
    if (tap) {
        currentLab = (UILabel*)tap.view;
    }else {
        currentLab = [self.titleLabs objectAtIndex:_selectIndex];
    }
    
    if (_currentIndex == currentLab.tag) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageTitleView:didSelectIndex:)]) {
            [self.delegate pageTitleView:self didSelectIndex:_currentIndex];
        }
        return;
    }
    
    currentLab.textColor = self.textSelectColor;
    
    //2.点击之前的旧label
    UILabel *oldLabel = [self.titleLabs objectAtIndex:_currentIndex];
    oldLabel.textColor = self.textNormalColor;
    
    _currentIndex = currentLab.tag;
    
    //3.滑块位置改变
    CGFloat linePositionX = currentLab.frame.size.width * currentLab.tag;
    CGRect rect = _scrollLine.frame;
    [UIView animateWithDuration:0.15 animations:^{
        _scrollLine.frame = CGRectMake(linePositionX, rect.origin.y, rect.size.width, rect.size.height);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageTitleView:didSelectIndex:)]) {
        [self.delegate pageTitleView:self didSelectIndex:_currentIndex];
    }
}

#pragma mark - Public
- (void)setTitleLabelWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    
    //取出sourceLabel和targetLabel
    UILabel *sourceLabel = [self.titleLabs objectAtIndex:sourceIndex];
    UILabel *targetLabel = [self.titleLabs objectAtIndex:targetIndex];
    
    //滑块渐变
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    
    CGRect rect = _scrollLine.frame;
    _scrollLine.frame = CGRectMake(sourceLabel.frame.origin.x + moveX, rect.origin.y, rect.size.width, rect.size.height);
    
    if (progress <= 1 && progress >= 0.5) {
        sourceLabel.textColor = self.textNormalColor;
        targetLabel.textColor = self.textSelectColor;
    }else {
        sourceLabel.textColor = self.textSelectColor;
        targetLabel.textColor = self.textNormalColor;
    }
    
    //4.记录最新的Index
    _currentIndex = targetIndex;
}

#pragma mark - Setter
- (void)setLabelWidth:(CGFloat)labelWidth {
    _labelWidth = labelWidth;
    if (_labelWidth * self.titles.count > self.frame.size.width) {//大于自身的宽度时，可以滑动
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_labelWidth * self.titles.count, 0);
        _scrollLine.frame = CGRectMake(_currentIndex * self.frame.size.width / self.titles.count, self.frame.size.height - kScrollLineH - 1, _labelWidth, kScrollLineH);
        for (NSInteger i=0; i<self.titles.count; i++) {
            UILabel *label = [self.titleLabs objectAtIndex:i];
            label.frame = CGRectMake(i * _labelWidth, 0, _labelWidth, self.frame.size.height - kScrollLineH);
        }
    }
}
- (void)setTextNormalColor:(UIColor *)textNormalColor {
    _textNormalColor = textNormalColor;
    for (UILabel *label in self.titleLabs) {
        label.textColor = _textNormalColor;
    }
}

- (void)setScrollLineColor:(UIColor *)scrollLineColor {
    _scrollLineColor = scrollLineColor;
    _scrollLine.backgroundColor = _scrollLineColor;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    [self labelClick:nil];
}

#pragma mark - Private
- (UIColor *)colorWithHexStr:(NSString *)hexStr
{
    if(hexStr.length<6)
        return UIColorFromRGB(0xFF5100);
    if([hexStr hasPrefix:@"#"])
        hexStr = [hexStr substringFromIndex:1];
    if(hexStr.length<6)
        return UIColorFromRGB(0xFF5100);
    
    NSRange range       = NSMakeRange(0, 2);
    NSString *aString   = nil;
    if ([hexStr length] == 8)//argb
    {
        aString         = [hexStr substringWithRange:range];
        range.location  = 2;
    }
    NSString *rString   =[hexStr substringWithRange:range];
    range.location      += 2;
    NSString *gString   =[hexStr substringWithRange:range];
    range.location      += 2;
    NSString *bString   =[hexStr substringWithRange:range];
    
    unsigned a,r,g,b;
    if (aString)
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    else
        a               = 255;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.];
}

@end
