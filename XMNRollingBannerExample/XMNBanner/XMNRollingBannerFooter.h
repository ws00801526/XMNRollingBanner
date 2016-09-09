//
//  XMNRollingBannerFooterView.h
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/9.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** footer状态 */
typedef NS_ENUM(NSUInteger, XMNRollingBannerFooterState) {
    
    /** 普通状态下 */
    XMNRollingBannerFooterStateIdle,
    /** 拖动到触发状态下 */
    XMNRollingBannerFooterStateTrigger,
};

/**
 *  @brief 提供footerView,当collectionView拖动到最底部时显示
 */
@interface XMNRollingBannerFooter : UICollectionReusableView

@property (assign, nonatomic) XMNRollingBannerFooterState state;
@property (assign, nonatomic) int rollingDirection;

@end
