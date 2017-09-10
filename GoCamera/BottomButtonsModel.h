//
//  BottomButtonsModel.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/5.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    EditType,
    FilterType,
    MagicType,
    MosaicType,
}BottomButtonType;

@interface BottomButtonsModel : NSObject

@property (nonatomic, strong) NSArray *normalNameArray;
@property (nonatomic, strong) NSArray *pressNameArray;
@property (nonatomic, strong) NSArray *buttonTitle;

@end
