//
//  presentOrderView.h
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jiesuanSubView.h"


@protocol presentOrderViewDelegate <NSObject>

- (void)addbuttonpresentOrder:(UIButton *)sender;

//礼品卡点击事件
- (void)subviewpresentOrder:(NSInteger)tags;

@end

@interface presentOrderView : UIView

@property (nonatomic, strong)jiesuanSubView *subview;

@property (nonatomic, assign)id<presentOrderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame arr:(NSMutableArray *)arr  canuser:(BOOL)canused;





@end
