//
//  presentOrderView.m
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "presentOrderView.h"
#import "PresentModel.h"
@interface presentOrderView   ()
{
    UIScrollView *scrollView;
}

@end

@implementation presentOrderView


- (instancetype)initWithFrame:(CGRect)frame arr:(NSMutableArray *)arr  canuser:(BOOL)canused
{
    if ([super initWithFrame:frame]) {
        
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            scrollView.showsHorizontalScrollIndicator = YES;
            scrollView.tag = 1000;
            scrollView.contentSize = CGSizeMake(arr.count * 240 + 10 + 100, 100);
            [self addSubview:scrollView];
        
        if (arr.count > 0) {
          
            for (int i = 0; i < arr.count; i++) {
                PresentModel *model  = arr[i];
                _subview = [[[NSBundle mainBundle] loadNibNamed:@"JieSuanSubView" owner:nil options:nil] firstObject];
                _subview.tag = 430 + i;
                _subview.frame  = CGRectMake(i * 240 + 10, 5, 230, 90);
                _subview.firstLab.text = [NSString stringWithFormat:@"礼品卡号 : %@",model.cardNo];
                _subview.seclab.text = model.status;
                //如果可以使用礼品卡
                if (canused) {
                    if ([model.status isEqualToString:@"已激活"]) {
                        _subview.seclab.textColor = [ColorString colorWithHexString:@"#f9cd02"];
                        _subview.backView.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
                    } else {
                        _subview.seclab.textColor = [UIColor blackColor];
                        _subview.backView.backgroundColor = [UIColor lightGrayColor];
                    }
                } else {
                    _subview.seclab.textColor = [UIColor blackColor];
                    _subview.backView.backgroundColor = [UIColor lightGrayColor];
                }
                
                _subview.threelab.text = [NSString stringWithFormat:@"面值 : %ld元",model.faceValue];
                _subview.fourlab.text = [NSString stringWithFormat:@"有效期限 : %@ %@",model.cardTime,model.cardCountType];
                [scrollView addSubview:_subview];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapsubview:)];
                [_subview addGestureRecognizer:tap];
                //此时是最后一个
                if (i == arr.count - 1) {
                    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                    btn.frame = CGRectMake((i + 1) * 240 + 10 , 10, 80, 80);
                    [btn setImage:[UIImage imageNamed:@"加号"] forState:(UIControlStateNormal)];
                 
                    [btn addTarget:self action:@selector(addpresentAction:) forControlEvents:(UIControlEventTouchUpInside)];
                    [scrollView addSubview:btn];
                }
                
            }
            
        } else {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake( 10 , 10, 80, 80);
            [btn setImage:[UIImage imageNamed:@"加号"] forState:(UIControlStateNormal)];
            [btn addTarget:self action:@selector(addpresentAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [scrollView addSubview:btn];
        }
        
        
    }
    return self;
}

- (void)tapsubview:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(subviewpresentOrder:)]) {
        [self.delegate subviewpresentOrder:tap.view.tag - 430];
    }
}

//点击事件
- (void)addpresentAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addbuttonpresentOrder:)]) {
        [self.delegate addbuttonpresentOrder:sender];
    }
}



@end
