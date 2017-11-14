//
//  PriceLine.h
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceLine : NSObject
//商品上方下划线
+(NSAttributedString *)priceLineMethod:(NSString *)textstr;
//按钮封装，图片在上，标题在下
+(void)initButton:(UIButton *)sender;

//
+(UITableViewCell *)tableViewcellFortable:(UITableView *)tableview textLab:(NSString *)textone imageStr:(NSString *)imagestr;
+(UITableViewCell *)tableViewcellFortable:(UITableView *)tableview textLab:(NSArray *)textArr imageArr:(NSArray *)imagearr  indexPath:(NSIndexPath *)index;


@end
