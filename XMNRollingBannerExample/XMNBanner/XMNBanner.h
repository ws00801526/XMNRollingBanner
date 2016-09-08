//
//  XMNBanner.h
//  XMNBanner
//
//  Created by XMFraker on 16/9/6.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for XMNBanner.
FOUNDATION_EXPORT double XMNBannerVersionNumber;

//! Project version string for XMNBanner.
FOUNDATION_EXPORT const unsigned char XMNBannerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <XMNBanner/PublicHeader.h>

#if __has_include(<XMNBanner/XMNBanner.h>)

    #import <XMNBanner/XMNRollingBanner.h>
    #import <XMNBanner/XMNRollingBannerCell.h>

#else

    #import "XMNRollingBanner.h"
    #import "XMNRollingBannerCell.h"

#endif