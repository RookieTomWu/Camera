//
//  BeautyMainMiddleView.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautyMainMiddleScrollView.h"

@protocol  BeautyMainMiddleViewDelegate<NSObject>
-(void)compareImageViewTaped:(UILongPressGestureRecognizer *)longPressGesture;
@end

@interface BeautyMainMiddleView : UIView

@property(nonatomic, strong)id <BeautyMainMiddleViewDelegate>beautyMainMiddleDelegate;
@property(nonatomic, strong)BeautyMainMiddleScrollView *mainMiddleScrollView;

@end
