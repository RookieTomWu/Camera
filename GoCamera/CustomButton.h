//
//  CustomButton.h
//  GoCamera
//
//  Created by Tomwu on 2017/5/5.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    BottomType,
    TopType,
    LeftType,
    RightType,
}CustomButtonType;

@interface CustomButton : UIButton

@property(nonatomic, strong) UIColor *textNormalColor;
@property(nonatomic, strong) UIColor *textSelectedColor;
@property(nonatomic, assign) CustomButtonType customType;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(CustomButtonType)type
              normalImageName:(NSString *)normalImageName
               pressImageName:(NSString *)pressImageName;

@end
