//
//  XMNRollingBannerController.h
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/5.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** banner 滚动方向*/
typedef NS_ENUM(NSUInteger, XMNBannerRollingDirection) {
    
    /** 不滚动 */
    XMNBannerRollingNone = 0,
    /** 向右侧滚动 */
    XMNBannerRollingHorizontal = 10,
    /** 向左侧滚动 */
    XMNBannerRollingVertical = 20,
    /** 默认滚动方向,右侧滚动 */
    XMNBannerRollingDefault = XMNBannerRollingHorizontal
};

/**
 *  @brief 实现无限循环滚动的BannerC
 */
IB_DESIGNABLE
@interface XMNRollingBanner : UIView

/// ========================================
/// @name   滚动相关属性
/// ========================================

/** banner的滚动方向
*  @warning  当设置为XMNBannerRollingNone 时,会停止滚动计时器,不在滚动
*            设置为其他属性时,不会自动开启定时器,仍需要手动调用 [bannerC startRolling]; 方法
**/
@property (assign, nonatomic) XMNBannerRollingDirection rollingDirection;

/** 图片滚动的时间间隔
 *  默认  2s
 *  @warning 修改duration的时候,会自动停止
 **/
@property (assign, nonatomic) NSTimeInterval duration;


/** 是否是逆向滚动
 *  默认 Horizontal   -> 向右侧滚动   Vertical 向上滚动
 *  默认NO
 **/
@property (assign, nonatomic) IBInspectable BOOL reverseRollingDirection;

/** 是否自动变化滚动方向 默认NO
 *  如果是YES  则滚动到最后一张图片后,会自动向另个方向滚动
 **/
@property (assign, nonatomic, getter=isAutoReverseRollingDirection) IBInspectable BOOL autoReverseRollingDirection;

/// ========================================
/// @name   内容相关属性
/// ========================================

/** 当前显示的index */
@property (assign, nonatomic, readonly) NSInteger currentIndex;

/** banner展示的图片数组 */
@property (copy, nonatomic, nonnull) NSArray *images;

/** 显示网络图片时 或者为传入 images数组时,默认展示的图片 */
@property (strong, nonatomic, nullable) IBInspectable UIImage *placeholderImage;

/// ========================================
/// @name   UI控件相关属性
/// ========================================

/** 提供显示pageControl
 *  未设置 默认使用UIPageControl
 *  注意使用自定义pageControl时,需要实现 currentPage,numberOfPages两个方法
 **/
@property (weak, nonatomic, nullable) UIView *pageControl;

/// ========================================
/// @name   其他属性
/// ========================================

/** 点击事件 */
@property (copy, nonatomic, nullable)   void(^tapBlock)(NSUInteger index);

/** 加载网络图片的block
 *
 *  @warning 如果未配置此block会导致网络图片无法显示
 **/
@property (copy, nonatomic, nullable)   void(^loadRemoteImageBlock)(UIImageView *__nonnull imageView, NSString *__nonnull imageURL, UIImage *__nullable placeHolderImage);

/**
 *  @brief 开始滚动
 */
- (void)startRolling;

/**
 *  @brief 停止滚动
 */
- (void)stopRolling;

/** 暂停滚动 */
- (void)pauseRolling;

/** 继续滚动 */
- (void)resumeRolling;

@end
