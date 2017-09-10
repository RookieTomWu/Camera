//
//  CustomButton.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/5.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame type:(CustomButtonType)type normalImageName:(NSString *)normalImageName pressImageName:(NSString *)pressImageName {
    self = [super initWithFrame:frame];
    if (self) {
        self.customType = type;
        [self config:normalImageName pressImageName:pressImageName];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.customType = BottomType;
    [self configure];
}

- (void) config:(NSString *)normalImageName
    pressImageName:(NSString *)pressImageName {
    [self setImage:IMAGENAMED(normalImageName) forState:UIControlStateNormal];
    [self setImage:IMAGENAMED(pressImageName) forState:UIControlStateHighlighted];
    [self configure];
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageWidth = self.currentImage.size.width;
    CGFloat imageHeight = self.currentImage.size.height;
    CGFloat imageOriginX = (self.frame.size.width - imageWidth) / 2;
    CGFloat imageOriginY = 0;
    switch (self.customType) {
        case TopType:
            imageOriginY = 20;
            break;
        case BottomType:
            break;
        case LeftType:
            break;
        case RightType:
            imageOriginY = 0;
            break;
        default:
            break;
    }
    return CGRectMake(imageOriginX, imageOriginY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleWidth = self.currentImage.size.width;
    CGFloat titleHeight = 20;
    CGFloat titleOriginX = (self.frame.size.width - (self.currentImage.size.width))/2;
    CGFloat titleOriginY = 0;
    switch (self.customType) {
        case TopType:
            break;
        case BottomType:
            titleOriginY = self.currentImage.size.height;
            break;
        case LeftType:
            titleOriginY = (self.frame.size.height - titleHeight)/2;
            titleWidth = self.frame.size.width - (self.currentImage.size.width);
            break;
        case RightType:
            titleOriginY = (self.frame.size.height - titleHeight)/2;
            break;
        default:
            break;
    }
    return CGRectMake(titleOriginX, titleOriginY, titleWidth, titleHeight);
}

- (void)configure {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}
@end
