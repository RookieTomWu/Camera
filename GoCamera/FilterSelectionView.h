//
//  FilterSelectionView.h
//  GoCamera
//
//  Created by Tomwu on 2017/4/27.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraFilterViewDelegate;

@interface FilterSelectionView : UIView
@property (strong, nonatomic, nullable) id <CameraFilterViewDelegate> cameraFilterDelegate;
@property(nonatomic, strong, nullable)NSArray *picArray;
@property(nonatomic, strong, nullable)NSArray *titleArray;


- (void)show;
- (void)hiden;

- (void)showWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;
- (void)hideWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

@end

@protocol CameraFilterViewDelegate <NSObject>

- (void)switchCameraFilter:(NSInteger)index;

@end
