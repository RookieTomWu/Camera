//
//  cameraCountdownView.h
//  GoCamera
//
//  Created by wxd on 2017/3/15.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol CameraCountdownViewDelegate;

@interface cameraCountdownView : UIView
{
    UILabel     *_secondsLabel;
    UILabel     *_animationLabel;
    NSTimer     *_countdownTimer;
    
    SystemSoundID soundID;
}

@property(nonatomic, assign)    NSInteger seconds;
@property(nonatomic, weak)      id<CameraCountdownViewDelegate> delegate;
@property(nonatomic, readonly)  UIView *secondsBackgroundView;
@property(nonatomic, strong)    UIImageView *bgImageView;

- (id)initWithSeconds:(NSInteger)seconds;
- (void)startCountdownTimer;

- (void)invalidateCountdownTimer;

@end

@protocol CameraCountdownViewDelegate <NSObject>

- (void)cameraCountdownViewDidCompleted;

@end
