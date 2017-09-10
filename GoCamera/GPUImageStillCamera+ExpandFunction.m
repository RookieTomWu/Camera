//
//  GPUImageStillCamera+ExpandFunction.m
//  GoCamera
//
//  Created by meitu on 2017/3/23.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "GPUImageStillCamera+ExpandFunction.h"

@implementation GPUImageStillCamera (ExpandFunction)

- (CGFloat)ISO
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_8_0) {
        return _inputCamera.ISO;
    }
    else {
        return 0;
    }
}

- (void)setISO:(CGFloat)ISO
{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_8_0) {
        CGFloat newISO = ISO;
        newISO = MIN(newISO, _inputCamera.activeFormat.maxISO);
        newISO = MAX(newISO, _inputCamera.activeFormat.minISO);
        CMTime exposureDuration = _inputCamera.exposureDuration;
        
        NSError *error = nil;
        if ([_inputCamera lockForConfiguration:&error]) {
            [_inputCamera setExposureModeCustomWithDuration:exposureDuration
                                                        ISO:newISO
                                          completionHandler:nil];
            [_inputCamera unlockForConfiguration];
        }
    }
}

@end
