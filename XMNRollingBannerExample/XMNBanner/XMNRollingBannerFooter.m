//
//  XMNRollingBannerFooterView.m
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/9.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingBannerFooter.h"

@interface XMNRollingBannerFooter ()

@property (weak, nonatomic)   UIImageView *arrowImageView;
@property (weak, nonatomic)   UILabel *tipsLabel;

@end

@implementation XMNRollingBannerFooter

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.rollingDirection == 10) {
        
        /** 水平滚动 */
        self.arrowImageView.frame = CGRectMake(12.f, self.bounds.size.height/2 - 8.f, 16.f, 16.f);
        self.tipsLabel.frame = CGRectMake(self.bounds.size.width/2 + 7, 0, 14, self.bounds.size.height);
    }else if (self.rollingDirection == 20){
        
        /** 垂直滚动 */
        self.arrowImageView.frame = CGRectMake(self.bounds.size.width/2 - 8.f, 12.f, 16.f, 16.f);
        self.tipsLabel.frame = CGRectMake( 0, self.bounds.size.height/2 + 7, self.bounds.size.width, 14);
    }
}

#pragma mark - Method

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleWithIdentifier:@"com.XMFraker.XMNBanner"] ? : [NSBundle mainBundle] pathForResource:@"banner_arrow@2x" ofType:@"png"]]];
    imageView.transform = CGAffineTransformMakeRotation(0);
    [self addSubview:self.arrowImageView = imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:115/255.f green:115/255.f blue:115/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:13.f];
    label.numberOfLines = 0;
    label.text = (self.state == XMNRollingBannerFooterStateIdle ? @"拖动查看详情" : @"松开查看详情");
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipsLabel = label];
}

#pragma mark - Setter

- (void)setState:(XMNRollingBannerFooterState)state {
    
    _state = state;
    self.tipsLabel.text = (state == XMNRollingBannerFooterStateIdle ? @"拖动查看详情" : @"松开查看详情");
    switch (state) {
        case XMNRollingBannerFooterStateTrigger:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(self.rollingDirection == 10 ? M_PI : M_PI_2);
            }];
        }
            break;
        default:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(self.rollingDirection == 10 ? 0 : -M_PI_2);
            }];
        }
            break;
    }
}

- (void)setRollingDirection:(int)rollingDirection {
    
    _rollingDirection = rollingDirection;
    self.arrowImageView.transform = CGAffineTransformMakeRotation(self.rollingDirection == 10 ? 0 : -M_PI_2);
}

@end
