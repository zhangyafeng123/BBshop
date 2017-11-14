//
//  PriceLine.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PriceLine.h"

@implementation PriceLine
+(NSAttributedString *)priceLineMethod:(NSString *)textstr
{
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:textstr attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
    
    return attr;
}
+(void)initButton:(UIButton *)sender
{
    sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//让图片和文字都居中显示
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(30, -sender.imageView.frame.size.width, 0.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [sender setImageEdgeInsets:UIEdgeInsetsMake(-20, 0.0,0.0, -sender.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边

    
}


+(UITableViewCell *)tableViewcellFortable:(UITableView *)tableview textLab:(NSString *)textone imageStr:(NSString *)imagestr
{
    static NSString *str = @"person";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = textone;
    cell.textLabel.font = H15;
    cell.imageView.image = [UIImage imageNamed:imagestr];
    return cell;
}
+(UITableViewCell *)tableViewcellFortable:(UITableView *)tableview textLab:(NSArray *)textArr imageArr:(NSArray *)imagearr  indexPath:(NSIndexPath *)index
{
    static NSString *str = @"person";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = H15;
    cell.textLabel.text = textArr[index.row];
    cell.imageView.image = [UIImage imageNamed:imagearr[index.row]];
    return cell;
}

@end
