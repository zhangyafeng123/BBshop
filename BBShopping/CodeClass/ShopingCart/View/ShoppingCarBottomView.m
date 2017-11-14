//
//  ShoppingCarBottomView.m
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ShoppingCarBottomView.h"
#import "ShoppingCarBottomModel.h"
@implementation ShoppingCarBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame With:(ShoppingCarBottomModel *)bottomModel{
    
    self = [super initWithFrame:frame];
    if(self)
    {
        _allselectBtn = [[UIButton alloc]init];
        _allselectBtn.tag = 650;
        
        [_allselectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_allselectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [_allselectBtn setTitle:@"全选" forState:(UIControlStateNormal)];
        [_allselectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _allselectBtn.titleLabel.font = H14;
        [_allselectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [_allselectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        _allselectBtn.selected = bottomModel.isSelect;
        [_allselectBtn addTarget:self action:@selector(alllselClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_allselectBtn];
        
        
        _resultPriceLl = [[UILabel alloc]init];
        _resultPriceLl.font = H13;
        _resultPriceLl.textAlignment = NSTextAlignmentRight;
        _resultPriceLl.textColor = [ColorString colorWithHexString:@"#f9cd02"];
        _resultPriceLl.text = bottomModel.priceText;
        _resultPriceLl.font = [UIFont systemFontOfSize:15];
        [self addSubview:_resultPriceLl];
        
        UILabel *newlab = [[UILabel alloc] init];
        newlab.text = @"不含运费";
        newlab.font = H13;
        newlab.textAlignment = NSTextAlignmentRight;
        [self addSubview:newlab];
        
        UIButton *endButton = [[UIButton alloc]init];
        endButton.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
        endButton.tag  = 651;
        NSString *endStr = [NSString stringWithFormat:@"结算(共%ld件)",(long)bottomModel.counts];
        endButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [endButton setTitle:endStr forState:UIControlStateNormal];
         [endButton addTarget:self action:@selector(alllselClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:endButton];
        
        
        _allselectBtn.frame = CGRectMake(10, 0, 100, 50);
        endButton.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, self.frame.size.height);
        _resultPriceLl.frame = CGRectMake(110, 0, SCREEN_WIDTH -110-110, 30);
        newlab.frame = CGRectMake(110, 30, SCREEN_WIDTH - 180-40, 20);
      
        
    }
    return self;
    
}

//全选点击
- (void)alllselClick:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(shoppingcarBottomViewDelegate:)])
    {
        [self.delegate shoppingcarBottomViewDelegate:sender];
    }
}

@end
