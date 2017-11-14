//
//  ShoppingCell.m
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ShoppingCell.h"
#import "ShoppingModel.h"
#import "HJCAjustNumButton.h"
@interface ShoppingCell()<HJCAjustNumButtonDelegate>
/**筛选按钮*/
@property (nonatomic,strong) UIButton *selectBtn;
/**商品*/
@property (nonatomic,strong) UILabel *goodsLb;
/**价格*/
@property (nonatomic,strong) UILabel *priceLb;

@property (nonatomic, strong)UIButton *deleteBtn;

/**商品图片*/
@property (nonatomic,strong) UIImageView *goodsImage;
@property (nonatomic, strong)HJCAjustNumButton *NumButton;

@end


static NSString *ID = @"cell";


@implementation ShoppingCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    ShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ShoppingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
    }
    return self;
}
/**
 *  初始化控件
 */
- (void) setupUI{
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    _selectBtn.tag = 0;
    [_selectBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    
    
    _NumButton = [[HJCAjustNumButton alloc] init];
    _NumButton.delegate = self;
    // 内容更改的block回调
    _NumButton.callBack = ^(NSString *currentNum){
        NSLog(@"%@", currentNum);
    };
    [self.contentView addSubview:_NumButton];
    
    _deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setImage:[UIImage imageNamed:@"乘号"] forState:(UIControlStateNormal)];
     [_deleteBtn addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    _goodsImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_goodsImage];
    
    _goodsLb = [[UILabel alloc]init];
    _goodsLb.font = [UIFont systemFontOfSize:14];
    _goodsLb.numberOfLines = 0;
    [self.contentView addSubview:_goodsLb];
    _priceLb = [[UILabel alloc]init];
    _priceLb.font = [UIFont systemFontOfSize:14];
    _priceLb.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLb];
    
    
    [self setUIFrame];
    
}
- (void)deleteButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shoppingCellDelegate:WithDeleteButton:)]) {
        [self.delegate shoppingCellDelegate:self WithDeleteButton:sender];
    }
}
- (void)clickButtonAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(shoppingCellDelegateForGoodsCount:WithCountButton:)])
    {
        [self.delegate shoppingCellDelegateForGoodsCount:self WithCountButton:sender];
    }
}
/**
 *  设置frame  120
 */
- (void)setUIFrame{
    
    _selectBtn.frame = CGRectMake(10, 50, 20, 20);
    _goodsImage.frame = CGRectMake(40, 10, 100, 100);
    _goodsLb.frame = CGRectMake(150, _goodsImage.frame.origin.y, SCREEN_WIDTH - 150 - 40, 40);
    _priceLb.frame = CGRectMake(150, 80, 60, 30);
    _NumButton.frame = CGRectMake(CGRectGetMaxX(_priceLb.frame), 80, 90, 30);
    _deleteBtn.frame = CGRectMake(CGRectGetMaxX(_goodsLb.frame)+5, 10, 25, 25);
    
}
/**
 *  模型赋值
 */
- (void)setModel:(ShoppingModel *)model
{
    self.selectBtn.selected = model.isSelect;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.picServerUrl1] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
    
    self.NumButton.currentNum =[NSString stringWithFormat:@"%ld",model.buycount];//数量
    self.goodsLb.text = model.goodsName;//商品标题
   
    self.priceLb.text = [NSString stringWithFormat:@"￥%.2f",model.groupBuyPrice];
    
}

/**
 *  选择按钮的点击方法
 */
- (void)selectButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shoppingCellDelegate:WithSelectButton:)])
    {
        [self.delegate shoppingCellDelegate:self WithSelectButton:sender];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
