//
//  CancelConfirmView.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "CancelConfirmView.h"

static NSInteger kLabelWidth = 200;

@implementation CancelConfirmView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = [UIColor clearColor];
    [self addCancelButton];
    [self addConfirmButton];
    [self addTitleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self updateLabelFrame];
}

- (void)cancelButtonPressed:(UIButton *)sender {
    if (self.cancelConfirmViewDelegate) {
        [self.cancelConfirmViewDelegate cancelButtonPressed];
    }
}

- (void)confirmButtonPressed:(UIButton *)sender {
    if (self.cancelConfirmViewDelegate) {
        [self.cancelConfirmViewDelegate confirmButtonPressed];
    }
}

- (void)addCancelButton {
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonClickWidth, kButtonClickWidth)];
    [cancelButton setImage:[UIImage imageNamed:@"cancelnormal"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"cancelprsd"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
}

- (void)addConfirmButton {
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - kButtonClickWidth, 0, kButtonClickWidth, kButtonClickWidth)];
    [confirmButton setImage:[UIImage imageNamed:@"confirmnormal"] forState:UIControlStateNormal];
    [confirmButton setImage:[UIImage imageNamed:@"confirmprsd"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
}

- (void)addTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self updateLabelFrame];
}

//动态计算label大小
-(void)updateLabelFrame {
    self.titleLabel.text = self.title;
    CGRect rect = [self.titleLabel textRectForBounds:CGRectMake((KScreenWidth - kLabelWidth), 0, kLabelWidth, self.bounds.size.height) limitedToNumberOfLines:1];
    self.titleLabel.frame = CGRectMake((KScreenWidth - rect.size.width)/2, (self.bounds.size.height - rect.size.height)/2, rect.size.width, rect.size.height);
}

@end
