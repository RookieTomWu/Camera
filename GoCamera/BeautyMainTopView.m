//
//  BeautyMainTopView.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "BeautyMainTopView.h"

@interface BeautyMainTopView () 

@end

@implementation BeautyMainTopView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addBackButton];
    [self addUndoButton];
    [self addRedoButton];
    [self addShareButton];
}

- (void)backBtnPressed:(UIButton *)sender {
    if (self.beautyMainTopViewDelegate) {
        [self.beautyMainTopViewDelegate backButtonPressed:sender];
    }
}

- (void)undoBtnPressed:(UIButton *)sender {
    if (self.beautyMainTopViewDelegate) {
        [self.beautyMainTopViewDelegate undoButtonPressed:sender];
    }
}

- (void)redoBtnPressed:(UIButton *)sender {
    if (self.beautyMainTopViewDelegate) {
        [self.beautyMainTopViewDelegate redoButtonPressed:sender];
    }
}

- (void)shareBtnPressed:(UIButton *)sender {
    if (self.beautyMainTopViewDelegate) {
        [self.beautyMainTopViewDelegate shareButtonPressed:sender];
    }
}

- (void)addBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonClickWidth, kButtonClickWidth)];
    [backButton setImage:[UIImage imageNamed:@"backnormal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backprsd"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
}

- (void)addUndoButton {
    _undoButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth/2 - kButtonClickWidth - 5, 0, kButtonClickWidth, kButtonClickWidth)];
    [_undoButton addTarget:self action:@selector(undoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_undoButton setImage:[UIImage imageNamed:@"undonormal"] forState:UIControlStateNormal];
    [_undoButton setImage:[UIImage imageNamed:@"undoprsd"] forState:UIControlStateHighlighted];
    _undoButton.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_undoButton];
}

- (void)addRedoButton {
    _redoButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth/2 + 5, 0, kButtonClickWidth, kButtonClickWidth)];
    [_redoButton addTarget:self action:@selector(redoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_redoButton setImage:[UIImage imageNamed:@"redonormal"] forState:UIControlStateNormal];
    [_redoButton setImage:[UIImage imageNamed:@"redoprsd"] forState:UIControlStateHighlighted];
    _redoButton.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_redoButton];
}

- (void)addShareButton {
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - kButtonClickWidth, 0, kButtonClickWidth, kButtonClickWidth)];
    [shareButton setImage:[UIImage imageNamed:@"sharenormal"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"shareprsd"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
}
@end
