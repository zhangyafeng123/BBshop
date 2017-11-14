//
//  waitheaderView.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/23.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface waitheaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong)UILabel *storelab;

@property (nonatomic, strong)UILabel *rightlab;
@property (nonatomic, strong)UIImageView *imageV;
@end
