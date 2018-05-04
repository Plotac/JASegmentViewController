//
//  JAPageContentView.m
//  JASegmentViewController
//
//  Created by Ja on 2018/4/26.
//  Copyright © 2018年 Ja. All rights reserved.
//

#import "JAPageContentView.h"
#import "DownloadViewController.h"

static NSString *const kCollectionViewCellID = @"kCollectionViewCellID";

@interface JAPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//该自定义View主要的视图
@property (nonatomic,strong) UICollectionView *collectionView;

//子控制器数组
@property (nonatomic,strong) NSArray<UIViewController*> *childVCs;

//父控制器
@property (nonatomic,strong) UIViewController *parentVC;

//默认滑动到哪个视图的index
@property (nonatomic,assign) NSInteger defaultIndex;

//是否禁用代理方法
@property (nonatomic,assign) BOOL isForbitScrollDelegate;

//偏移量
@property (nonatomic,assign) CGFloat startOffsetX;

@end

@implementation JAPageContentView

#pragma mark - 初始化方法 & UI
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray<UIViewController*>*)childVCs parentVC:(UIViewController*)parentVC defaultIndex:(NSInteger)defaultIndex delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.childVCs = childVCs;
        self.parentVC = parentVC;
        self.defaultIndex = defaultIndex > childVCs.count - 1 ? 0 : defaultIndex;
        
        self.delegate = delegate;
        
        _isForbitScrollDelegate = NO;
        _scrollCovered = NO;
        
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    
    for (UIViewController *vc in self.childVCs) {
        [self.parentVC addChildViewController:vc];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.bounces = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
    [self addSubview:_collectionView];
    
    [_collectionView setContentOffset:CGPointMake(self.defaultIndex * _collectionView.frame.size.width, 0)];
    _startOffsetX = _collectionView.contentOffset.x;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UIScrollViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCs.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController *childVC = [self.childVCs objectAtIndex:indexPath.item];
    childVC.view.backgroundColor = [UIColor whiteColor];
    childVC.view.frame = cell.bounds;
    if ([childVC isMemberOfClass:[DownloadViewController class]]) {
        DownloadViewController *vc = (DownloadViewController*)childVC;
        vc.label.text = [NSString stringWithFormat:@"DownloadViewController, index: %ld",(long)indexPath.row];
    }
    [cell.contentView addSubview:childVC.view];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isForbitScrollDelegate = NO;
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _scrollCovered = NO;
    
    //判断是否是点击事件
    if (_isForbitScrollDelegate)  return;
    
    CGFloat progress = 0;
    NSInteger sourcesIndex = 0;
    NSInteger targetIndex = 0;
    
    CGFloat currentOffset = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    
    if (currentOffset > _startOffsetX) {//左滑
        //左滑：currentOffset增加 所以currentOffset / scrollViewW 是大于0的小数
        //floor()函数 : 取整
        progress = currentOffset / scrollViewW - floor(currentOffset / scrollViewW);// x.y - x = 0.y
        if (progress >= 0.9) {
            _scrollCovered = YES;
        }
        
        sourcesIndex = currentOffset / scrollViewW;
        
        targetIndex = sourcesIndex + 1;
        if (targetIndex >= self.childVCs.count) {//防止越界
            targetIndex = self.childVCs.count - 1;
        }
        
        //如果完全滑过去
        if (currentOffset - _startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = sourcesIndex;
        }
        
        
    }else {//右滑
        //右滑：currentOffset减少 所以currentOffset / scrollViewW 是大于0小于1的小数
        progress = 1 - (currentOffset / scrollViewW - floor(currentOffset / scrollViewW));
        if (progress >= 0.9) {
            _scrollCovered = YES;
        }
        
        targetIndex = currentOffset / scrollViewW;
        
        sourcesIndex = targetIndex + 1;
        if (sourcesIndex >= self.childVCs.count) {//防止越界
            sourcesIndex = self.childVCs.count - 1;
        }
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentView:self progress:progress sourceIndex:sourcesIndex targetIndex:targetIndex];
    }
}

#pragma mark - Public
- (void)setContentViewCurrentIndex:(NSInteger)index {
    //如果是滑动的话，禁止代理方法
    _isForbitScrollDelegate = YES;
    
    CGFloat offsetX = index * _collectionView.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
    [_collectionView reloadData];
}

@end
