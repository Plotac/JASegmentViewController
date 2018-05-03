//
//  JASegmentViewController.m
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import "JASegmentViewController.h"
#import "JAPageTitleView.h"
#import "JAPageContentView.h"
#import "DetailViewController.h"
#import "ProgramViewController.h"
#import "DownloadViewController.h"

// UI常量
static CGFloat const titleViewHeight = 40;

static CGFloat const titleViewVisibleLabelCount = 5;

// Defines
// 判断是否为iPhone X
#define IS_IPHONE_X   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) == 812.0)
// 系统状态栏高度
#define kStatusBarHeight   (IS_IPHONE_X ? 44.0f : MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height))
// 系统导航栏高度
#define kNavToolBarHeight  44

@interface JASegmentViewController ()<JAPageTitleViewDelegate,JAPageContentViewDelegate>

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) JAPageTitleView *titleView;

@property (nonatomic,strong) JAPageContentView *contentView;

@end

@implementation JASegmentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.style == JASegmentViewControllerStyleDefault) {
        _topView = nil;
    }else {
        _topView = [[UIView alloc]init];
        _topView.frame = CGRectMake(0, kStatusBarHeight + kNavToolBarHeight, [[UIScreen mainScreen]bounds].size.width, 120 * [[UIScreen mainScreen]bounds].size.width/320);
        _topView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_topView];
    }
    
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"详情",@"节目",@"已下载",@"4",@"5",@"6",@"7", nil];
    CGFloat titleViewY = self.style == JASegmentViewControllerStyleDefault ? kStatusBarHeight + kNavToolBarHeight : CGRectGetMaxY(_topView.frame);
    _titleView = [[JAPageTitleView alloc]initWithFrame:CGRectMake(0, titleViewY, [[UIScreen mainScreen]bounds].size.width, titleViewHeight) titles:titleArray defaultIndex:1 needBottomLine:YES delegate:self];
//    _titleView.textSelectColor = [UIColor redColor];
//    _titleView.textNormalColor = [UIColor greenColor];
//    _titleView.scrollLineColor = [UIColor purpleColor];
    _titleView.labelWidth = [[UIScreen mainScreen]bounds].size.width / titleViewVisibleLabelCount;
    [self.view addSubview:_titleView];
    
    DetailViewController *detailVC = [DetailViewController new];
    ProgramViewController *programVC = [ProgramViewController new];
    DownloadViewController *downloadVC = [DownloadViewController new];
    DownloadViewController *downloadVC1 = [DownloadViewController new];
    DownloadViewController *downloadVC2 = [DownloadViewController new];
    DownloadViewController *downloadVC3 = [DownloadViewController new];
    DownloadViewController *downloadVC4 = [DownloadViewController new];
    NSArray *childVCs = [[NSArray alloc]initWithObjects:detailVC,programVC,downloadVC,downloadVC1,downloadVC2,downloadVC3,downloadVC4, nil];
    CGFloat height = self.style == JASegmentViewControllerStyleDefault ? 0 : _topView.frame.size.height;
    
    _contentView = [[JAPageContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - kStatusBarHeight - kNavToolBarHeight - height - titleViewHeight) childVCs:childVCs parentVC:self defaultIndex:1 delegate:self];
    [self.view addSubview:_contentView];
}

#pragma mark - JAPageContentViewDelegate
- (void)pageContentView:(JAPageContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    [_titleView setTitleLabelWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];

    if (!contentView.scrollCovered) return;
    
    CGFloat offsetX = _titleView.scrollView.contentOffset.x;
    NSInteger currentIndex = _titleView.currentIndex;
    
    if (currentIndex >= titleViewVisibleLabelCount - 2) {
        if (offsetX <= 0) {
            [_titleView.scrollView setContentOffset:CGPointMake(offsetX + _titleView.labelWidth, 0) animated:YES];
        }else if(offsetX > 0) {
            if (floor(offsetX) < floor((_titleView.titleArray.count - titleViewVisibleLabelCount) * _titleView.labelWidth)) {
                [_titleView.scrollView setContentOffset:CGPointMake(offsetX + _titleView.labelWidth, 0) animated:YES];
            }else if(currentIndex <= titleViewVisibleLabelCount - 2) {
                [_titleView.scrollView setContentOffset:CGPointMake(offsetX - _titleView.labelWidth, 0) animated:YES];
            }
        }
    }else {
        [_titleView.scrollView setContentOffset:CGPointZero animated:YES];
    }
}

#pragma mark - JAPageTitleViewDelegate
- (void)pageTitleView:(JAPageTitleView *)titleView didSelectIndex:(NSInteger)index {
    [_contentView setContentViewCurrentIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
