//
//  ButtonBorderColorManager.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonBorderColorManager : NSObject
//right
+(void)setbuttonbordercolor:(UIButton *)btn btntitle:(NSString *)str;
//other
+(void)setbuttonNormalbordercolor:(UIButton *)btn buttontitle:(NSString *)str;
@end
