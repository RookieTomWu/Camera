//
//  HomeViewController.m
//  GoCamera
//
//  Created by wxd on 2017/3/16.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "HomeViewController.h"
#import "Masonry.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *homeBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *whiteMaskImageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (weak, nonatomic) IBOutlet UIView   *bottomContantView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self masonryLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)masonryLayoutSubviews {
    CGFloat width = self.homeBackgroundImageView.image.size.width;
    CGFloat height = self.homeBackgroundImageView.image.size.height;
    [self.homeBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(KScreenWidth * height/width);
    }];
    
    [self.whiteMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.homeBackgroundImageView.mas_bottom);
        make.left.equalTo(self.homeBackgroundImageView);
        make.right.equalTo(self.homeBackgroundImageView);
        make.height.mas_equalTo(140.0);
    }];
    
    [self.bottomContantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeBackgroundImageView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    CGFloat cameraBtnImageWidth = self.cameraBtn.currentBackgroundImage.size.width;
    CGFloat cameraBtnImageHeight = self.cameraBtn.currentBackgroundImage.size.height;
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomContantView);
        make.width.mas_equalTo(cameraBtnImageWidth);
        make.height.mas_equalTo(cameraBtnImageHeight);
    }];
    
    [self.settingsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-25);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}

- (IBAction)camerAction:(id)sender {
}

- (IBAction)settingsAction:(id)sender {
}

@end
