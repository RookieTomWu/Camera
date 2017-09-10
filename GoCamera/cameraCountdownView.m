//
//  cameraCountdownView.m
//  GoCamera
//
//  Created by wxd on 2017/3/15.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "cameraCountdownView.h"

@implementation cameraCountdownView

#pragma mark - CameraCountdownView LifeCycle
- (id)initWithSeconds:(NSInteger)seconds
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.seconds = seconds;
        
        _secondsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [_secondsBackgroundView setBackgroundColor:[UIColor clearColor]];
        _secondsBackgroundView.center = self.center;
        _secondsBackgroundView.frame = CGRectMake(_secondsBackgroundView.frame.origin.x,
                                                  _secondsBackgroundView.frame.origin.y - 10,
                                                  _secondsBackgroundView.frame.size.width,
                                                  _secondsBackgroundView.frame.size.height);
        [self addSubview:_secondsBackgroundView];
        
        _secondsLabel = [[UILabel alloc] initWithFrame:CGRectInset(_secondsBackgroundView.bounds, 10, 10)];
        _secondsLabel.text = [NSString stringWithFormat:@"%ld", (long)seconds];
        _secondsLabel.font = [UIFont systemFontOfSize:60];
        _secondsLabel.backgroundColor = [UIColor clearColor];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
        _secondsLabel.textColor = RGBAHEX(0xff6258, 1);
        [_secondsBackgroundView addSubview:_secondsLabel];
        
        _animationLabel = [[UILabel alloc] initWithFrame:CGRectInset(_secondsBackgroundView.bounds, 10, 10)];
        _animationLabel.text = [NSString stringWithFormat:@"%ld", (long)seconds];
        _animationLabel.font = [UIFont systemFontOfSize:60];
        _animationLabel.backgroundColor = [UIColor clearColor];
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.textColor = RGBAHEX(0xff6258, 1);
        _animationLabel.hidden = YES;
        [_secondsBackgroundView addSubview:_animationLabel];
//        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_countdown_view.png"]];
//        self.bgImageView.frame = CGRectMake(0, 0, 70, 70);
//        [_secondsBackgroundView addSubview:self.bgImageView];
//        [_secondsBackgroundView sendSubviewToBack:self.bgImageView];
    }
    return self;
}

- (void)dealloc{
    [self invalidateCountdownTimer];
}

#pragma mark - CameraCountdownView Public Methods
- (void)setSeconds:(NSInteger)seconds {
    _seconds = seconds;
    _secondsLabel.text = [NSString stringWithFormat:@"%ld", (long)_seconds];
}

- (void)invalidateCountdownTimer
{
    if ([_countdownTimer isValid]) {
        [_countdownTimer invalidate];
    }
    
    _secondsLabel.alpha = 1.0;
    self.bgImageView.alpha = 1.0;
    _countdownTimer = nil;
}

- (void)startCountdownTimer
{
    [self invalidateCountdownTimer];
    _secondsLabel.alpha = 1.0;
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleCountdownTimer:) userInfo:nil repeats:YES];
}

- (void)handleCountdownTimer:(NSTimer *)timer
{
    if (_seconds > 0)
    {
        _secondsLabel.text = [NSString stringWithFormat:@"%ld", (long)_seconds];
        _animationLabel.text = _secondsLabel.text;
        _animationLabel.hidden = NO;
        _animationLabel.alpha = 1.0;
        
        [UIView animateWithDuration:0.9 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.bgImageView.alpha = 0.0;
            _animationLabel.alpha = 0.0;
            _secondsLabel.alpha = 0.0;
            _animationLabel.transform = CGAffineTransformMakeScale(4, 4);
            self.bgImageView.transform = CGAffineTransformMakeScale(4, 4);
        } completion:^(BOOL finished) {
            _animationLabel.hidden = YES;
            if (_seconds > 1) {
                _secondsLabel.alpha = 1.0;
                self.bgImageView.alpha = 1.0;
            }
            _animationLabel.transform = CGAffineTransformIdentity;
            self.bgImageView.transform = CGAffineTransformIdentity;
            _seconds--;
        }];
    }
    else
{
        // finish
        [_delegate cameraCountdownViewDidCompleted];
        [self invalidateCountdownTimer];
        _seconds = 0;
    }
}

@end
