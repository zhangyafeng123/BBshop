//
//  EditAddressViewController.h
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"
@interface EditAddressViewController : BaseViewController

@property (nonatomic, copy)NSString *cityStr;
@property (nonatomic, copy)NSString *districtStr;
@property (nonatomic, copy)NSString *provinceStr;
@property (nonatomic, copy)NSString *nameStr;
@property (nonatomic, copy)NSString *phoneStr;
@property (nonatomic, copy)NSString *detailStr;
@property (nonatomic, copy)NSString *btnstr;
@property (nonatomic, assign)NSInteger editid;
@end
