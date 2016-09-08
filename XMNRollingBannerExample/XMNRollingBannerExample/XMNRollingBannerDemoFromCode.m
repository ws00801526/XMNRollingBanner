//
//  XMNRollingBannerDemoFromCode.m
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/6.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingBannerDemoFromCode.h"
#import "ViewController.h"

#import "UIImageView+YYWebImage.h"

@interface XMNRollingBannerDemoFromCode ()

@property (strong, nonatomic)   XMNRollingBanner *rollingBanner;


@end

@implementation XMNRollingBannerDemoFromCode


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.rollingBanner = [[XMNRollingBanner alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    /** 配置滚动时间间隔 */
    self.rollingBanner.duration = 3.f;
    /** 配置显示的数组 */
    self.rollingBanner.bannerModels = @[[[XMNTestBannerModel alloc] initWithImage:[UIImage imageNamed:@"1"]],
                                        [[XMNTestBannerModel alloc] initWithImage:[UIImage imageNamed:@"2"]],
                                        //                                  [UIImage imageNamed:@"3"],
                                        //                                  [UIImage imageNamed:@"4"],
                                        //                                  [UIImage imageNamed:@"5"],
                                        [[XMNTestBannerModel alloc] initWithImage:@"http://scs.ganjistatic1.com/gjfs01/M00/89/F4/CgEHklWmXzvov6K-AABrKnXXM9U624_600-0_6-0.jpg"],
                                        [[XMNTestBannerModel alloc] initWithImage:@"http://img6.faloo.com/Picture/0x0/0/183/183366.jpg"],
                                        ];
    
    /** 设置默认placeholder */
    self.rollingBanner.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    /** 配置逆向滚动,如果YES  则 Horizontal -> 向左侧滚动  Vertical 向下滚动 */
    //        self.rollingBanner.reverse = YES;
//    self.rollingBanner.autoReverseRollingDirection = YES;
    /** 设置self.rollingBanner 的滚动方向 */
//    self.rollingBanner.rollingDirection = XMNBannerRollingVertical;
    
    [self.rollingBanner setTapBlock:^(NSUInteger index) {
        
        NSLog(@"i have tap index :%d",(int)index);
    }];
    
    [self.rollingBanner setLoadRemoteImageBlock:^(UIImageView * imageView, NSString * imageURL, UIImage * placeholder) {
        
        [imageView yy_cancelCurrentImageRequest];
        [imageView yy_setImageWithURL:[NSURL URLWithString:imageURL] placeholder:placeholder];
    }];
    
    [self.view addSubview:self.rollingBanner];
}


- (void)dealloc {
    
    NSLog(@"%@  dealloc",self);
}


@end
