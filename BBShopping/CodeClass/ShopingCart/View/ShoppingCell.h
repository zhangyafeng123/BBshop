//
//  ShoppingCell.h
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingModel;
@class ShoppingCell;
@protocol ShoppingCellDelegate <NSObject>

/**
 *  cell关于选中的代理方法
 *
 *  @param cell     cell
 *  @param selectBt cell左边选中按钮
 */
- (void)shoppingCellDelegate:(ShoppingCell *)cell WithDeleteButton:(UIButton *)sender;
- (void)shoppingCellDelegate:(ShoppingCell *)cell WithSelectButton:(UIButton *)selectBt;
/**
 *  cell关于数量编辑的代理方法
 *
 *  @param cell    cell
 *  @param countBt cell加减数量按钮
 */
- (void)shoppingCellDelegateForGoodsCount:(ShoppingCell *)cell WithCountButton:(UIButton *)countBt;

@end
@interface ShoppingCell : UITableViewCell
@property (nonatomic,strong) ShoppingModel *model;


/**cell代理对象*/
@property(nonatomic,assign)id<ShoppingCellDelegate> delegate;



+ (instancetype) cellWithTableView :(UITableView *)tableView;
@end
