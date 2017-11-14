//
//  BaseViewController.h
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface BaseViewController : UIViewController

/**
 *  显示loading动画
 */
- (void)showProgressHUD;
/**
 *  隐藏loading动画
 */
- (void)hideProgressHUD;

//显示带有文字的loading
- (void)showProgressHUDWithThitle:(NSString *)title;


@end
