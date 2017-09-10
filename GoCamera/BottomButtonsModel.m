//
//  BottomButtonsModel.m
//  GoCamera
//
//  Created by Tomwu on 2017/5/5.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "BottomButtonsModel.h"

@implementation BottomButtonsModel

- (NSArray *)normalNameArray {
    if (!_normalNameArray) {
        _normalNameArray = [NSArray arrayWithObjects:@"editnormal", @"filternormal", @"magicnormal", @"mosaicnormal", nil];
    }
    return _normalNameArray;
}


- (NSArray *)pressNameArray {
    if (!_pressNameArray) {
        _pressNameArray = [NSArray arrayWithObjects:@"editPressed", @"filterPressed", @"magicPressed", @"mosaicPressed", nil];
    }
    return _pressNameArray;
}

-(NSArray *)buttonTitle {
    if (!_buttonTitle) {
        _buttonTitle = [NSArray arrayWithObjects:@"编辑", @"滤镜", @"魔棒", @"模糊", nil];
    }
    return _buttonTitle;
}
@end
