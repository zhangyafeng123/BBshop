//
//  SearchViewController.h
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"
//排序 0综合排序 1按价格升序排序 2按价格降序排序 3按销售降序排序 4按评价降序排序 5按最新上架时间降序排序
typedef NS_OPTIONS(NSInteger, NumberTypeActions){
    ActionTypeOne = 0,
    ActionTypeTwo = 1,
    ActionTypeThree = 2,
    ActionTypeFour = 3,
    ActionTypeFive = 4,
    ActionTypeSix  = 5
};
@interface SearchViewController : BaseViewController



@end
