//
//  XMNRollingBanner.m
//  XMNRollingBannerExample
//
//  Created by XMFraker on 16/9/5.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingBannerCell.h"

@interface XMNRollingBannerCell ()

@property (weak, nonatomic)   UIImageView *imageView;

@end

@implementation XMNRollingBannerCell

#pragma mark - Life Cycle

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

#pragma mark - Method

- (void)setupUI {
    
    /** 添加显示图片的imageView */
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView = imageView];

    /** 配置imageView自适应布局 */
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    id viewsDic = NSDictionaryOfVariableBindings(_imageView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:viewsDic]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:viewsDic]];
}

- (void)loadImage {
    
    
    if ([self.image isKindOfClass:[NSString class]]) {
        
        NSURL *url = [NSURL URLWithString:self.image];
        if (!url) {
            self.imageView.image = self.placeholderImage;
            return;
        }else if ([url isFileURL]) {
            
            self.imageView.image = [UIImage imageWithContentsOfFile:[url absoluteString]];
        }else {
            
            self.loadRemoteImageBlock ? self.loadRemoteImageBlock(_imageView, _image, _placeholderImage) : nil;
        }
        
    }else if ([self.image isKindOfClass:[UIImage class]]) {
        self.imageView.image = self.image;
    }else {
        self.imageView.image = self.placeholderImage;
    }
}

#pragma mark - Setter

- (void)setImage:(id)image {
    
    _image = image;
    [self loadImage];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    
    _placeholderImage = placeholderImage;
    if (!self.imageView.image) {
        self.imageView.image = placeholderImage;
    }
}

@end
