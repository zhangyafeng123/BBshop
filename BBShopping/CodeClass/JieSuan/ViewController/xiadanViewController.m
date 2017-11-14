//
//  xiadanViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "xiadanViewController.h"
#import "ZhifuFangShiViewController.h"
#import "PresentQueRenZhiFuViewController.h"

@interface xiadanViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightheighConstranint;
@property (weak, nonatomic) IBOutlet UILabel *leftsecLab;
@property (weak, nonatomic) IBOutlet UILabel *leftneedLab;
@property (nonatomic, strong)NSDictionary *orderDic;
@property (weak, nonatomic) IBOutlet UILabel *firstlab;
@property (weak, nonatomic) IBOutlet UILabel *seclab;
@property (weak, nonatomic) IBOutlet UILabel *threelab;
@property (weak, nonatomic) IBOutlet UILabel *threeleftlab;
@property (weak, nonatomic) IBOutlet UILabel *Alab;
@property (weak, nonatomic) IBOutlet UILabel *Blab;
@property (weak, nonatomic) IBOutlet UILabel *Clab;
@end

@implementation xiadanViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下单成功";
    //设置不允许侧滑
    self.backPanEnabled = NO;
   
    self.Alab.text = [NSString stringWithFormat:@"收货人:%@", self.xiadanDic[@"receiveName"]];
    
    self.Blab.text = [NSString stringWithFormat:@"联系电话:%@",self.xiadanDic[@"receiveMobile"]];
    
    self.Clab.text = self.addressNew;
    [self showProgressHUD];
    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?totalFee=%.2f&giftCardPrice=%.2f&serialNumber=%@",payindexURL,[self.xiadanDic[@"realPayment"] floatValue],[self.xiadanDic[@"giftCardPrice"] floatValue],self.xiadanDic[@"serialNumber"]] parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.orderDic = responseObject[@"map"][@"orderPayDTO"];
            self.seclab.text = [NSString stringWithFormat:@"¥%.2f",[self.orderDic[@"giftCardPrice"] floatValue]];
            
            self.threelab.text = [NSString stringWithFormat:@"¥%.2f",[self.orderDic[@"totalFee"] floatValue]];
            if ([self.threelab.text isEqualToString:@"¥0.00"]) {
                self.threelab.hidden = YES;
                self.leftneedLab.hidden = YES;
            } else {
                self.threelab.hidden = NO;
                self.leftneedLab.hidden = NO;
            }
            if ([self.seclab.text isEqualToString:@"¥0.00"]) {
                self.seclab.hidden = YES;
                self.leftsecLab.hidden = YES;
                self.heighConstraint.constant = 2;
                self.rightheighConstranint.constant = 2;
                self.leftneedLab.text = @"支付金额:";
               
            } else {
                self.seclab.hidden = NO;
                self.leftsecLab.hidden = NO;
                self.heighConstraint.constant = 32;
                self.rightheighConstranint.constant = 32;
            }
            
            self.firstlab.text = [NSString stringWithFormat:@"%@",self.orderDic[@"serialNumber"]];
            
        }
        [self hideProgressHUD];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)nextView:(UIButton *)sender {
    
    //判断是否是礼品卡支付
    if ([self.threelab.text isEqualToString:@"¥0.00"]) {
        //
        PresentQueRenZhiFuViewController *present = [PresentQueRenZhiFuViewController new];
        present.presentDic = self.orderDic;
        [self.navigationController pushViewController:present animated:YES];
    } else {
    //支付宝、微信支付界面
    ZhifuFangShiViewController *zhifu = [ZhifuFangShiViewController new];
    zhifu.weixinDic =self.orderDic;
    [self.navigationController pushViewController:zhifu animated:YES];
    }
}

@end
