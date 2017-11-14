//
//  HomeFirstCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeFirstCellDelegate <NSObject>

- (void)tapClickAction:(NSInteger)number;

@end

@interface HomeFirstCell : UICollectionViewCell

@property (nonatomic, assign)id<HomeFirstCellDelegate>delegate;

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *titleLab;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)collectviewCellForArray:(NSMutableArray *)arr;

@end
