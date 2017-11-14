//
//  AddressCell.h
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong)AddressModel *model;
@end
