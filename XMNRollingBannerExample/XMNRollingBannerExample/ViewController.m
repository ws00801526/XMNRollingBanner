//
//  ViewController.m
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/2.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "ViewController.h"
#import "XMNRollingBannerDemoFromCode.h"

#import <XMNBanner/XMNBanner.h>

#import "YYWebImage.h"
#import "UIImageView+YYWebImage.h"


@implementation XMNTestBannerModel

- (instancetype)initWithImage:(id)image {
 
    if (self = [super init]) {
        
        self.image = image;
    }
    return self;
}

@end

@interface ViewController ()

@property (weak, nonatomic) IBOutlet XMNRollingBanner *rollingBanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** 测试,每次都清空图片缓存,查看图片下载情况 */
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
//    self.rollingBanner.placeholderImage = [UIImage imageNamed:@"6"];
    
    /** 配置逆向滚动,如果YES  则 Horizontal -> 向左侧滚动  Vertical 向下滚动 */
    //        self.rollingBanner.reverse = YES;
    self.rollingBanner.autoReverseRollingDirection = NO;
    /** 设置self.rollingBanner 的滚动方向 */
    self.rollingBanner.rollingDirection = XMNBannerRollingHorizontal;
    
    __weak typeof(*&self) wSelf = self;
    [self.rollingBanner setTapBlock:^(NSUInteger index) {
        
        __strong typeof(*&wSelf) self = wSelf;
        [self handleTap:index];
    }];
    
    [self.rollingBanner setFooterTriggerBlock:^{
       
        NSLog(@"触发了查看更多功能");
    }];
    
    [self.rollingBanner setLoadRemoteImageBlock:^(UIImageView * imageView, NSString * imageURL, UIImage * placeholder) {
        
        [imageView yy_cancelCurrentImageRequest];
        [imageView yy_setImageWithURL:[NSURL URLWithString:imageURL] placeholder:placeholder];
    }];
    
    self.rollingBanner.shouldShowFooter = YES;
    
    /** @warning 如果使用xib直接初始化的方式, 则需要手动 */
    [self.rollingBanner startRolling];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// ========================================
///  @warning 建议在willAppear,willDisappear
///  中调用对应的暂停滚动 [self.rollingBanner pauseRolling];
///  继续滚动方法        [self.rollingBanner resumeRolling];
/// ========================================

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear",NSStringFromClass([self class]));
    [self.rollingBanner resumeRolling];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear",NSStringFromClass([self class]));
    [self.rollingBanner pauseRolling];
}


- (void)handleTap:(NSInteger)index {
    
    NSLog(@"i will push to another banner which create with code");
    XMNRollingBannerDemoFromCode *fromCodeC = [[XMNRollingBannerDemoFromCode alloc] init];
    [self.navigationController pushViewController:fromCodeC animated:YES];
}

@end
