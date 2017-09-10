//
//  BeautyMainBottomView.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "BeautyMainBottomView.h"
#import "BottomButtonsModel.h"
#import "CustomButton.h"

static NSInteger kBeautyMainBottomButtonCount = 4;

@interface BeautyMainBottomView (){
    CGFloat _beautyMainBottomButtomWidth;
    UIScrollView *_bottomScrollView;
}

@end

@implementation BeautyMainBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _beautyMainBottomButtomWidth = (KScreenWidth - 20)/4;
    [self addScrollView];
    [self addButtons];
}

- (void)beautyBottomBtnPressed:(UIButton *)sender {
    if (self.beautyMainBottomViewDelegate) {
        [self.beautyMainBottomViewDelegate beautyBottomButtonPressed:sender];
    }
}

- (void)addScrollView {
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _bottomScrollView.showsVerticalScrollIndicator = NO;
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.contentSize = CGSizeMake(kBeautyMainBottomButtonCount * _beautyMainBottomButtomWidth, self.bounds.size.height);
    [self addSubview:_bottomScrollView];
}

- (void)addButtons {
    BottomButtonsModel *model = [[BottomButtonsModel alloc] init];
    for (NSInteger i = 0; i<kBeautyMainBottomButtonCount; i++) {
        UIButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(i * _beautyMainBottomButtomWidth, 0, _beautyMainBottomButtomWidth, self.frame.size.height) type:BottomType normalImageName:model.normalNameArray[i] pressImageName:model.pressNameArray[i]];
        button.tag = kBeautyMainBottomButtonStartTag + i;
        [button setTitle:model.buttonTitle[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(beautyBottomBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomScrollView addSubview:button];
    }
}

@end
