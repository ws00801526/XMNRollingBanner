//
//  XMNRollingBannerController.m
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/5.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingBanner.h"
#import "XMNRollingBannerCell.h"
#import "XMNRollingBannerFooter.h"

static NSInteger kXMNRollingBannerMaxSection = 20000;

@interface XMNRollingBanner () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger currentIndex;
@property (weak, nonatomic, readonly)   UICollectionViewFlowLayout *collectionLayout;

@property (weak, nonatomic)   UIImageView *emptyImageView;
@property (weak, nonatomic)   UICollectionView *collectionView;
@property (strong, nonatomic) XMNRollingBannerFooter *footer;
@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic, readonly) UICollectionViewScrollPosition scrollPosition;
@property (assign, nonatomic, readonly) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic, readonly) CGSize footerReferenceSize;
@property (assign, nonatomic, readonly) UIEdgeInsets contentInsets;


@end


@implementation XMNRollingBanner
@synthesize shouldLoop = _shouldLoop;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        NSLog(@"init with adecoder");
        [self setup];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSLog(@"init with frame");
        [self setup];
        [self setupUI];
    }
    return self;
}


- (void)dealloc {
    
    NSLog(@"%@  dealloc",self);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (!newSuperview) {
        /** 停止计时器功能 */
        [self stopRolling];
    }else {
        [self startRolling];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.collectionLayout setItemSize:self.bounds.size];
}

#pragma mark - Method

/**
 *  @brief 初始化RollingBannerController的默认属性值
 */
- (void)setup {
    
    self.rollingDirection = XMNBannerRollingDefault;
    self.duration = 2.f;
    self.currentIndex = 0;
    self.reverseRollingDirection = NO;
    self.shouldLoop = YES;
    self.footerWidth = 64.f;
}

- (void)setupUI {

    /** 添加collectionView */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = .0f;
    layout.footerReferenceSize = self.footerReferenceSize;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.contentOffset = CGPointZero;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[XMNRollingBannerCell class] forCellWithReuseIdentifier:@"XMNRollingBannerCell"];
    [collectionView registerClass:[XMNRollingBannerFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XMNRollingBannerFooter"];

    [self addSubview:self.collectionView = collectionView];
    
    /** 配置collectionView 默认配置 */
    self.collectionView.bounces = !self.isAutoReverseRollingDirection;
    self.collectionView.bouncesZoom = !self.isAutoReverseRollingDirection;
    self.collectionLayout.scrollDirection = self.scrollDirection;
    
    if (!self.pageControl) {
        /** 添加pageControl指示器 */
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        pageControl.numberOfPages = self.bannerModels.count;
        self.pageControl = pageControl;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.hidden = self.bannerModels && self.bannerModels.count;
    imageView.image = self.placeholderImage;
    [self addSubview:self.emptyImageView = imageView];
    
    /** 实现pageControl,collectionView,emptyImageView的自动布局 */
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _emptyImageView.translatesAutoresizingMaskIntoConstraints = NO;
    id viewsDic = NSDictionaryOfVariableBindings(_collectionView, _emptyImageView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:viewsDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:viewsDic]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_emptyImageView]|" options:0 metrics:nil views:viewsDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emptyImageView]|" options:0 metrics:nil views:viewsDic]];
    
    
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}


#pragma mark - Rolling Timer Method

/**
 *  @brief 开始滚动,启动定时前效果
 */
- (void)startRolling {
    
    self.timer ? [self.timer invalidate] : nil;
    self.timer = [NSTimer timerWithTimeInterval:self.duration target:self selector:@selector(handleRolling) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

//    /** 尝试 首次延迟出发 */
//    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.duration]];
}

- (void)stopRolling {
    
    self.timer ? [self.timer invalidate] : nil;
    self.timer = nil;
}

- (void)pauseRolling {
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeRolling {
    
    [self.timer setFireDate:[NSDate dateWithTimeInterval:self.duration sinceDate:[NSDate date]]];
}

- (void)handleRolling {
    
    
    if (self.collectionView.numberOfSections == 0 || self.rollingDirection == XMNBannerRollingNone || self.bannerModels.count <= 1) {
        /** 不处理以上情况下的自动滚动 */
        return;
    }
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSInteger item;
    NSInteger section = indexPath.section;
    /** 代表是否已经滚动带最后个,或者滚动到第一个 */
    BOOL reset = NO;
    NSIndexPath *scrollIndexPath;

    if (!self.reverseRollingDirection) {    /** 正常滚动方向 */
        
        item = indexPath.item+1;
        if (item >= self.bannerModels.count) {
            item = 0;
            section ++;
        }
        if (section >= self.collectionView.numberOfSections) {
            section = 0;
            reset = YES;
        }
        if (reset && self.isAutoReverseRollingDirection) {
            NSLog(@"scroll to right ,reverse direction to left");
            self.reverseRollingDirection = !self.reverseRollingDirection;
            [self handleRolling];
            return;
        }
    }else { /** 处理逆向滚动 */
        item = indexPath.item - 1;
        if (item < 0) {
            item = self.bannerModels.count - 1;
            section --;
        }
        if (section < 0) {
            section = self.collectionView.numberOfSections - 1;
            reset = YES;
        }
        if (reset && self.isAutoReverseRollingDirection) {
            NSLog(@"scroll to left ,reverse scroll direction");
            self.reverseRollingDirection = !self.reverseRollingDirection;
            [self handleRolling];
            return;
        }
    }
    
    NSLog(@"\nnext item :%d\nsection :%d",(int)item,(int)section);
    
    /** 如果需要重置了,并且不循环滚动,则不处理了 */
    if (reset && !self.shouldLoop) {
        return;
    }
    
    scrollIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    if (scrollIndexPath && scrollIndexPath.item < self.bannerModels.count && scrollIndexPath.section < self.collectionView.numberOfSections && scrollIndexPath.item >= 0 && scrollIndexPath.section >= 0) {
        
        [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:self.scrollPosition animated:!reset];
        self.currentIndex = item;
    }
}

- (void)handleFooterTap {
    
    self.footerTriggerBlock ? self.footerTriggerBlock() : nil;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    /** 不无限滚动 ,都返回一个section */
    return self.shouldLoop ? kXMNRollingBannerMaxSection : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.bannerModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMNRollingBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNRollingBannerCell" forIndexPath:indexPath];
    bannerCell.loadRemoteImageBlock = self.loadRemoteImageBlock;
    bannerCell.placeholderImage = self.placeholderImage;
    bannerCell.image = [self.bannerModels[indexPath.item] image];
    return bannerCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        if (!self.footer) {
            self.footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XMNRollingBannerFooter" forIndexPath:indexPath];
            self.footer.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFooterTap)];
            [self.footer addGestureRecognizer:tap];
        }
        self.footer.rollingDirection = self.rollingDirection;
        self.footer.hidden = !self.shouldShowFooter;
        return self.footer;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.tapBlock ? self.tapBlock(indexPath.row) : nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self pauseRolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self resumeRolling];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x + self.collectionView.bounds.size.width/2, scrollView.contentOffset.y + self.collectionView.bounds.size.height/2)];
    if (indexPath && indexPath.item != NSNotFound) {
        
        self.currentIndex = indexPath.item;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (!self.shouldShowFooter) {
        return;
    }
    
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset;
    if (self.rollingDirection == XMNBannerRollingVertical) {
        footerDisplayOffset = (scrollView.contentOffset.y - (self.bounds.size.height * (self.bannerModels.count - 1)));
    }else {
        footerDisplayOffset = (scrollView.contentOffset.x - (self.bounds.size.width * (self.bannerModels.count - 1)));
    }
    if (footerDisplayOffset > 0) {
        // 开始出现footer
        if (footerDisplayOffset >= self.footerWidth) {
            if (lastOffset > 0) return;
            self.footer.state = XMNRollingBannerFooterStateTrigger;
        } else {
            if (lastOffset < 0 || footerDisplayOffset >= self.footerWidth) return;
            self.footer.state = XMNRollingBannerFooterStateIdle;
        }
        lastOffset = footerDisplayOffset - self.footerWidth;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.shouldShowFooter) return;
    
    CGFloat footerDisplayOffset;
    if (self.rollingDirection == XMNBannerRollingVertical) {
        footerDisplayOffset = (scrollView.contentOffset.y - (self.bounds.size.height * (self.bannerModels.count - 1)));
    }else {
        footerDisplayOffset = (scrollView.contentOffset.x - (self.bounds.size.width * (self.bannerModels.count - 1)));
    }
    // 通知footer代理
    if (footerDisplayOffset > self.footerWidth && self.footer.state == XMNRollingBannerFooterStateTrigger) {
        [self handleFooterTap];
    }
}

#pragma mark - Setter

- (void)setPageControl:(UIView *)pageControl {
    
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    [self addSubview:_pageControl = pageControl];
    
    [(UIPageControl *)_pageControl  setNumberOfPages:self.bannerModels.count];
    [(UIPageControl *)_pageControl  setCurrentPage:self.currentIndex];
    
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    id viewsDic = NSDictionaryOfVariableBindings(_pageControl);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pageControl]|" options:0 metrics:nil views:viewsDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]|" options:0 metrics:nil views:viewsDic]];
}

- (void)setDuration:(NSTimeInterval)duration {
    
    _duration = MAX(1.f, duration);
    [self stopRolling];
}

- (void)setBannerModels:(NSArray<id<XMNBannerModel>> *)bannerModels {
    
    if (!bannerModels || !bannerModels.count) {
        self.emptyImageView.hidden = NO;
    }else {
        self.emptyImageView.hidden = YES;
    }
    _bannerModels = [bannerModels copy];
    
    [(UIPageControl *)self.pageControl  setNumberOfPages:bannerModels.count];
    [self.collectionView reloadData];
}

- (void)setAutoReverseRollingDirection:(BOOL)autoReverseRollingDirection {
    
    _autoReverseRollingDirection = autoReverseRollingDirection;
    self.shouldLoop = !autoReverseRollingDirection;
    self.collectionView.bounces = !autoReverseRollingDirection;
    self.collectionView.bouncesZoom = !autoReverseRollingDirection;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (_currentIndex == currentIndex) {
        return;
    }
    if (_currentIndex < 0 || _currentIndex >= self.bannerModels.count) {
        return;
    }
    _currentIndex = currentIndex;
    [(UIPageControl *)self.pageControl  setCurrentPage:currentIndex];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    
    _placeholderImage = placeholderImage;
    self.emptyImageView.image = placeholderImage;
}

- (void)setTapBlock:(void (^)(NSUInteger))tapBlock {
    
    _tapBlock = tapBlock;
}

- (void)setLoadRemoteImageBlock:(void (^)(UIImageView * _Nonnull, NSString * _Nonnull, UIImage * _Nullable))loadRemoteImageBlock {
    
    _loadRemoteImageBlock = loadRemoteImageBlock;
}


- (void)setRollingDirection:(XMNBannerRollingDirection)rollingDirection {
    
    if (_rollingDirection == rollingDirection) {
        return;
    }
    _rollingDirection = rollingDirection;
    switch (rollingDirection) {
        case XMNBannerRollingVertical:
        case XMNBannerRollingHorizontal:
            self.collectionLayout.scrollDirection = self.scrollDirection;
            self.collectionLayout.footerReferenceSize = self.footerReferenceSize;

            [self startRolling];
            break;
        default:
            [self stopRolling];
            break;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

- (void)setShouldLoop:(BOOL)shouldLoop {
    
    _shouldLoop = shouldLoop;
    
    if (_shouldLoop) {
        
        /** 修改shouldShowFooter */
        if (self.shouldShowFooter) {
            _shouldShowFooter = NO;
            self.footer.hidden = YES;
        }
        /** 修改可以autoReverseRollingDirection属性  为NO*/
        _autoReverseRollingDirection = NO;
    }
    
    self.collectionLayout.footerReferenceSize = self.footerReferenceSize;

    [self.collectionView reloadData];
}

- (void)setShouldShowFooter:(BOOL)shouldShowFooter {
    
    _shouldShowFooter = shouldShowFooter;
    self.collectionLayout.footerReferenceSize = self.footerReferenceSize;

    [self.collectionView reloadData];
}

- (void)setFooterWidth:(CGFloat)footerWidth {
    
    _footerWidth = footerWidth;
    self.collectionLayout.footerReferenceSize = self.footerReferenceSize;
    [self.collectionView reloadData];
}

#pragma mark - Getter

- (BOOL)shouldLoop {
    
    if (self.shouldShowFooter || self.autoReverseRollingDirection || !self.bannerModels || self.bannerModels.count <= 1) {
        /** 以上几种情况,均不需要无限循环滚动 */
        return NO;
    }
    return _shouldLoop;
}

- (UICollectionViewFlowLayout *)collectionLayout {
    
    return (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

- (UICollectionViewScrollDirection)scrollDirection {
    
    return self.rollingDirection == XMNBannerRollingVertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
}

- (UICollectionViewScrollPosition)scrollPosition {
    
    return self.rollingDirection == XMNBannerRollingVertical ? UICollectionViewScrollPositionCenteredVertically : UICollectionViewScrollPositionCenteredHorizontally;
}

- (CGSize)footerReferenceSize {
    
    if (self.shouldLoop) {
        return CGSizeZero;
    }
    return self.rollingDirection == XMNBannerRollingVertical ? CGSizeMake(self.bounds.size.width, self.footerWidth) : CGSizeMake(self.footerWidth, self.bounds.size.height);
}

- (UIEdgeInsets)contentInsets {
    
    if (self.shouldLoop) {
        return UIEdgeInsetsZero;
    }
    return self.rollingDirection == XMNBannerRollingVertical ? UIEdgeInsetsMake(0, 0, -self.footerWidth, 0.f) : UIEdgeInsetsMake(0, 0, 0, -self.footerWidth);
}

@end
