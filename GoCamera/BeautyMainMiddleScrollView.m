//
//  BeautyMainMiddleScrollView.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "BeautyMainMiddleScrollView.h"

#import "ImageModel.h"

@implementation BeautyMainMiddleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self configScrollView];
    [self addImageView];
}

- (void)configScrollView {
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)addImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.image = [ImageModel shareInstance].rawImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    [self setImageSize];
    [self addSubview:_imageView];
}

- (void)setImageSize {
    CGSize imageSize = [self sizeThatFits:self.bounds.size];
    _imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (!_imageView.image) {
        _imageView.image = [ImageModel shareInstance].rawImage;
    }
    CGFloat imgWidth = self.imageView.image.size.width;
    CGFloat imgHeight = self.imageView.image.size.height;
    CGFloat scale = self.imageView.image.scale;

    CGSize imageSize = CGSizeZero;
    imageSize = CGSizeMake(imgWidth / scale, imgHeight / scale);
    
    CGFloat widthRatio = imgWidth / size.width;
    CGFloat heightRatio = imgHeight / size.height;
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
