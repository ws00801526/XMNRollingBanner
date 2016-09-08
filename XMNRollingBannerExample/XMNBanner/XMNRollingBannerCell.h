//
//  XMNRollingBanner.h
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/5.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMNRollingBannerCell : UICollectionViewCell

/** 展示图片的imageView */
@property (weak, nonatomic, readonly, nullable)  UIImageView *imageView;

/** 需要被显示的图片 */
@property (strong, nonatomic, nonnull) id image;
/** 默认占位图 */
@property (strong, nonatomic, nullable) UIImage *placeholderImage;

/** 当前bannerC的index标识 */
@property (assign, nonatomic) NSUInteger index;

/** 加载网络图片处理 */
@property (copy, nonatomic, nullable)   void(^loadRemoteImageBlock)(UIImageView *__nonnull imageView, NSString *__nonnull imageUrlStr, UIImage *__nullable placeHolderImage);

@end
