//
//  ViewController.h
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/2.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMNBanner/XMNBanner.h>

@interface XMNTestBannerModel : NSObject <XMNBannerModel>

@property (strong, nonatomic) id image;

- (instancetype)initWithImage:(id)image;

@end

@interface ViewController : UIViewController


@end

