//
//  PresentQueRenZhiFuViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PresentQueRenZhiFuViewController.h"
#import "SuccessPayViewController.h"
@interface PresentQueRenZhiFuViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;

@end

@implementation PresentQueRenZhiFuViewController
- (IBAction)okButton:(id)sender {
    NSString *str = self.presentDic[@"serialNumber"];
    [self showProgressHUD];
    [PPNetworkHelper POST:giftCardPayURL parameters:@{@"orderNo":str} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            SuccessPayViewController *sucess = [SuccessPayViewController new];
            [self.navigationController pushViewController:sucess animated:YES];
        } else if ([responseObject[@"code"] integerValue] == 5007){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self hideProgressHUD];
        
    } failure:^(NSError *error) {
        
    }];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认支付";
    self.firstLab.text = [NSString stringWithFormat:@"%@",self.presentDic[@"serialNumber"]];
    self.secondLab.text = [NSString stringWithFormat:@"¥%.2f",[_presentDic[@"giftCardPrice"] floatValue]];
}


@end
