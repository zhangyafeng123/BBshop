//
//  TimeBtnView.h
//  BBShopping
//
//  Created by mibo02 on 17/2/15.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeBtnViewDelegate <NSObject>

- (void)clickBtnAction:(UIButton *)sender;

@end

@interface TimeBtnView : UIView

@property (nonatomic, assign)id<TimeBtnViewDelegate>delegate;

@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UILabel *textlab;
@property (nonatomic, strong)UIButton *buyBtn;


- (instancetype)initWithFrame:(CGRect)frame;


@end
