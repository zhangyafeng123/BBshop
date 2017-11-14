//
//  ShoppingCarBottomView.h
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCarBottomModel;
@class ShoppingCarBottomView;

@protocol ShoppingCarBottomViewDelegate <NSObject>

- (void)shoppingcarBottomViewDelegate:(UIButton *)allselBtn;

@end
@interface ShoppingCarBottomView : UIView
/**模型属性控制bt的状态*/
@property(nonatomic,strong)ShoppingCarBottomModel * bottomModel;
/**全选按钮*/
@property(nonatomic,strong)UIButton * allselectBtn;
/**总价label*/
@property(nonatomic,strong)UILabel * resultPriceLl;
/**总价label*/
@property(nonatomic,strong)void(^settleBlock)();
/**总价label*/
@property(nonatomic,assign)id<ShoppingCarBottomViewDelegate>delegate;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame With:(ShoppingCarBottomModel*)bottomModel;

@end
