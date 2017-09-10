//
//  ShowItemScrollView.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/6.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowItemScrollViewDelegate <NSObject>

- (void)itemScrollButtonPressed:(UIButton *_Nullable)button;

@end

@interface ShowItemScrollView : UIScrollView

@property (nonatomic, strong, nullable) id <ShowItemScrollViewDelegate>itemScrollViewDelegate;

- (instancetype _Nullable )initWithFrame:(CGRect)frame imageArray:(NSArray *_Nullable)array;

@end
