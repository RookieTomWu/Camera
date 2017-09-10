//
//  BeautyMainTopView.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeautyMainTopViewDelegate;

@interface BeautyMainTopView : UIView

@property (nonatomic, strong) id<BeautyMainTopViewDelegate>beautyMainTopViewDelegate;
@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *redoButton;

@end

@protocol BeautyMainTopViewDelegate <NSObject>

- (void)backButtonPressed:(UIButton *)sender;
- (void)undoButtonPressed:(UIButton *)sender;
- (void)redoButtonPressed:(UIButton *)sender;
- (void)shareButtonPressed:(UIButton *)sender;

@end
