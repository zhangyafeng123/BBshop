//
//  ShoppingCarHeadView.h
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingHeaderModel;
@class ShoppingCarHeadView;

@protocol  ShoppingCarHeaderViewDelegate<NSObject>

- (void)shoppingCarHeaderViewDelegat:(UIButton *)bt WithHeadView:(ShoppingCarHeadView *)view;

@end
@interface ShoppingCarHeadView : UIView
/**全选按钮*/
@property (nonatomic,strong) UIButton *selectAllBtn;

@property(nonatomic,assign)id<ShoppingCarHeaderViewDelegate>delegate;


//初始化方法
- (instancetype)initWithFrame:(CGRect)frame WithSection:(NSInteger)section HeadModel:(ShoppingHeaderModel *)model;
@end
