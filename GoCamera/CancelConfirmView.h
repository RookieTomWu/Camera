//
//  CancelConfirmView.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CancelConfirmViewDelegate;

@interface CancelConfirmView : UIView

@property(nonatomic, strong)NSString * _Nonnull title;
@property(nonatomic, strong)UILabel * _Nonnull titleLabel;
@property(nonatomic, strong, nullable)id<CancelConfirmViewDelegate>cancelConfirmViewDelegate;

@end

@protocol CancelConfirmViewDelegate <NSObject>

- (void)cancelButtonPressed;
- (void)confirmButtonPressed;

@end
