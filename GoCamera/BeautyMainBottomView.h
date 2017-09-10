//
//  BeautyMainBottomView.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/4.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BeautyMainBottomViewDelegate;

@interface BeautyMainBottomView : UIView

@property (nonatomic, strong, nullable) id<BeautyMainBottomViewDelegate>beautyMainBottomViewDelegate;

@end

@protocol BeautyMainBottomViewDelegate <NSObject>

- (void)beautyBottomButtonPressed:(UIButton *_Nullable)sender;

@end
