//
//  ShowItemScrollView.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/6.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "ShowItemScrollView.h"

static NSInteger kItemScrollViewStartTag = 11030;

@interface ShowItemScrollView(){
    CGFloat _imageWidth;
    CGFloat _margin;
}

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation ShowItemScrollView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        _imageWidth = 35;
        _margin = 6;
        self.imageArray = array;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = [UIColor clearColor];
    NSInteger count = self.imageArray.count;
    self.contentSize = CGSizeMake((_imageWidth + _margin) * count, _imageWidth);
    
    for (int i = 0; i<count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (_imageWidth + _margin), 0, _imageWidth, _imageWidth)];
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:IMAGENAMED(self.imageArray[i]) forState:UIControlStateNormal];
        button.tag = kItemScrollViewStartTag + i;
        [button addTarget:self action:@selector(itemScrollButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)itemScrollButtonPressed:(UIButton *)sender {
    for (UIButton *btn in self.subviews) {
        if (btn.tag == sender.tag) {
            btn.layer.borderColor = [UIColor orangeColor].CGColor;
            btn.layer.borderWidth = 1;
        } else {
            btn.layer.borderWidth = 0;
        }
    }
    
    if (self.itemScrollViewDelegate) {
        [self.itemScrollViewDelegate itemScrollButtonPressed:sender];
    }
}

@end
