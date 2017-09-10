//
//  FilterSelectionView.m
//  GoCamera
//
//  Created by Tomwu on 2017/4/27.
//  Copyright © 2017年 meitu. All rights reserved.
//

#import "FilterSelectionView.h"
@interface FilterSelectionView()<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger _currentSelected;
    BOOL _isshowing;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FilterSelectionView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _isshowing = NO;
    _currentSelected = 1;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"原图", @"美颜", @"阳光", @"幽暗", @"灰白", @"怀旧", @"素描", @"可爱", @"唯美", @"柔光", @"甜美", nil];
        _titleArray = array;
    }
    return _titleArray;
}

- (NSArray *)picArray {
    if (!_picArray) {
        NSMutableArray *imgArray = [NSMutableArray array];
        NSArray *array = [[NSArray alloc] initWithObjects:@"filtered_original", @"filtered_original", @"filtered_brighter", @"filtered_darker", @"filtered_sepia",@"filtered_black",@"filtered_original",@"filtered_original", @"filtered_original", @"filtered_original", @"filtered_original",nil];
        for (NSString *imgName in array) {
            UIImage *image = [UIImage imageNamed:imgName];
            [imgArray addObject:image];
        }
        _picArray = [imgArray copy];
    }
    return _picArray;
}
#pragma mark - publicMethods
- (void)show {
    [self showWithAnimated:YES completion:nil];
}

- (void)hiden {
    [self hideWithAnimated:YES completion:nil];
}

- (void)showWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion {
    [self setFrame:[self animateDestinationFrameForShowing] animated:animated animatingBlock:nil
        completion:^ {
            if (completion != nil) {
                completion();
            }
            _isshowing = YES;
        }];
}

- (void)hideWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion {
    [self setFrame:[self animateDestinationFrameForHiding] animated:animated animatingBlock:nil
        completion:^ {
            if (completion != nil) {
                completion();
            }
            _isshowing = NO;
        }];
}


#pragma mark - Show & Hide Animation
- (CGRect)animateDestinationFrameForShowing {
    if (self.superview == nil) {
        return CGRectZero;
    }
    CGRect animateDestinationFrame = self.frame;
    animateDestinationFrame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(animateDestinationFrame);
    
    return animateDestinationFrame;
}

- (CGRect)animateDestinationFrameForHiding {
    CGRect animateDestinationFrame = self.frame;
    animateDestinationFrame.origin.y = CGRectGetHeight(self.superview.bounds);
    
    return animateDestinationFrame;
}

- (void)setFrame:(CGRect)destinationFrame animated:(BOOL)animated animatingBlock:(nullable void (^)(void))animatingBlock completion:(nullable void (^)(void))completion {
    CGFloat duration = animated ? 0.30 : 0.00;
    [UIView animateWithDuration:duration animations:^ {
        self.frame = destinationFrame;
        if (animatingBlock != nil) {
            animatingBlock();
        }
    } completion:^ (BOOL finished) {
        if (completion != nil) {
            completion();
        }
    }];
}

#pragma UICollectionView datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.picArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cameraFilterCellID";
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.cornerRadius = cell.bounds.size.width / 2;
    if (indexPath.row == _currentSelected) {
        cell.layer.borderWidth = 5;
        cell.layer.borderColor = RGBAHEX(0xff6258, 1).CGColor;
    } else {
        cell.layer.borderWidth = 0;
        cell.layer.borderColor = [UIColor clearColor].CGColor;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, cell.frame.size.height-10)];
    imageView.image = [self.picArray objectAtIndex:indexPath.row];
    imageView.layer.cornerRadius = cell.frame.size.width / 2.0 - 5;
    imageView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 17)];
    titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:titleLabel];
    titleLabel.center = imageView.center;
    [cell addSubview:imageView];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark collecton flowlayout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KScreenWidth - 4) / 5, (KScreenWidth - 4) / 5);
}

#pragma mark collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentSelected != indexPath.row) {
       _currentSelected = indexPath.row;
        [self.collectionView reloadData];
    }
    [_cameraFilterDelegate switchCameraFilter:indexPath.row];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (IBAction)dismissAction:(id)sender {
    if (_isshowing) {
        [self hiden];
    }
}

@end
