//
//  BeautyMainMiddleView.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "BeautyMainMiddleView.h"

@interface BeautyMainMiddleView ()

@property(nonatomic, strong)UIImageView *compareImageView;

@end

@implementation BeautyMainMiddleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _mainMiddleScrollView = [[BeautyMainMiddleScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bounds.size.height - 30)];
    [self addSubview:_mainMiddleScrollView];
    UIImage *compareNormalImage = [UIImage imageNamed:@"comparenormal"];
    CGFloat buttonWidth = compareNormalImage.size.width;
    CGFloat buttonHeight = compareNormalImage.size.height;
    _compareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - buttonWidth, _mainMiddleScrollView.bounds.size.height - 30, buttonWidth, buttonHeight)];
    _compareImageView.image = compareNormalImage;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(compareImageViewTaped:)];
    longPressGesture.minimumPressDuration = 0.2;
    [_compareImageView addGestureRecognizer:longPressGesture];
    [self addSubview:_compareImageView];
}

-(void)compareImageViewTaped:(UILongPressGestureRecognizer *)longPressGesture {
    UIImage *compareNormalImage = [UIImage imageNamed:@"comparenormal"];
    UIImage *comparePressImage = [UIImage imageNamed:@"comparePress"];
    if (longPressGesture.state == UIGestureRecognizerStateBegan ||
        longPressGesture.state == UIGestureRecognizerStateCancelled) {
        self.compareImageView.image = comparePressImage;
    } else {
        self.compareImageView.image = compareNormalImage;
    }
    
    if (self.beautyMainMiddleDelegate) {
        [self.beautyMainMiddleDelegate compareImageViewTaped:longPressGesture];
    }
}
@end
