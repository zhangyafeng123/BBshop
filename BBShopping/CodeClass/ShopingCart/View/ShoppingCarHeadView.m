//
//  ShoppingCarHeadView.m
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ShoppingCarHeadView.h"
#import "ShoppingHeaderModel.h"

@interface ShoppingCarHeadView()

/**家园名称*/
@property (nonatomic,strong) UILabel *homeNameLb;

@end
@implementation ShoppingCarHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame WithSection:(NSInteger)section HeadModel:(ShoppingHeaderModel *)model{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //全选按钮
        _selectAllBtn = [[UIButton alloc]init];
        [_selectAllBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_selectAllBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [_selectAllBtn addTarget:self action:@selector(allClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllBtn.selected = model.isSelect;
        _selectAllBtn.tag = section + 1000;
        [self addSubview:_selectAllBtn];
        
        //家园名称
        _homeNameLb = [[UILabel alloc] init];
        _homeNameLb.textColor = [UIColor blackColor];
        _homeNameLb.font = [UIFont systemFontOfSize:14];
        _homeNameLb.text = model.store_name;
        [self addSubview:_homeNameLb];
        
        _selectAllBtn.frame = CGRectMake(10, 5, 20, 20);
       
        _homeNameLb.frame = CGRectMake(50, 5, 150, 20);
        
    }
    return self;
}

- (void)allClick:(UIButton *)bt
{
    if([self.delegate respondsToSelector:@selector(shoppingCarHeaderViewDelegat:WithHeadView:)])
    {
        [self.delegate shoppingCarHeaderViewDelegat:bt WithHeadView:self];
    }
}


@end
