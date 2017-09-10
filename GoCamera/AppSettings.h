//
//  AppSettings.h
//  GoCamera
//
//  Created by meitu on 2017/3/16.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RatioType) {
    RatioType1V1  = 0,
    RatioType3V4  = 1,
    RatioTypeFull = 2,
};

typedef NS_ENUM(NSInteger, FlashState) {
    FlashStateOn = 0,
    FlashStateOff = 1,
    FlashStateAtuo = 2,
};

typedef NS_ENUM(NSInteger, DelayCaptureMmode) {
    DelayCaptureClose = 0,
    DelayCapture3s    = 1,
    DelayCapture6s    = 2
};

@interface AppSettings : NSObject

@end
