//
//  BeautyMainMiddleScrollView.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeautyMainMiddleScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;

- (void)setImageSize;

@end
