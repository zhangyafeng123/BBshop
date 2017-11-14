//
//  TQXJViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/19.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TQXJViewController.h"

@interface TQXJViewController ()
@property (weak, nonatomic) IBOutlet UILabel *weixin;

@property (weak, nonatomic) IBOutlet UITextField *yanzhengM;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;


@end

@implementation TQXJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
   
    self.navigationController.navigationBar.translucent = NO;
    self.weixin.layer.borderColor = [UIColor redColor].CGColor;
    self.weixin.layer.borderWidth = 0.5;
}
- (IBAction)tixianBtnAction:(UIButton *)sender {
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showSuccess:@"手机号不能为空"];
        return;
    }
    if (self.yanzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    if (self.password.text.length == 0) {
        [MBProgressHUD showError:@"提现密码不能为空"];
        return;
    }
    [PPNetworkHelper GET:order_cashURL parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 20009) {
            [MBProgressHUD showError:@"必须微信登陆才可以哦"];
        } else if ([responseObject[@"code"] integerValue] == 20010){
            [MBProgressHUD showSuccess:@"请进入系统设置绑定提现手机号"];
        } else if ([responseObject[@"code"] integerValue] == 20011){
            [MBProgressHUD showSuccess:@"请设置提现密码"];
        } else if ([responseObject[@"code"] integerValue] ==20012 ){
            [MBProgressHUD showError:@"没有可以现金额"];
        } else if ([responseObject[@"code"] integerValue] == 20013){
            [MBProgressHUD showError:@"提现金额不能小于1元"];
        } else if (![self.password.text isEqualToString:responseObject[@"map"][@"orderCashView"][@"extractPassword"]]){
            [MBProgressHUD showError:@"提现密码不正确"];
            
        } else {
            
                NSDictionary *dic = responseObject[@"map"][@"orderCashView"];
                //请求提现申请
                [PPNetworkHelper POST:doCashURL parameters:@{@"appOpenId":dic[@"appOpenId"],@"canBalance":[NSString stringWithFormat:@"%.2f",[dic[@"canBalance"] floatValue]],@"extractPassword":dic[@"extractPassword"],@"validateMobile":dic[@"validateMobile"],@"code":self.yanzhengM.text} success:^(id responseObject) {
                    if ([responseObject[@"code"] integerValue] == 0) {
                        [MBProgressHUD showError:@"提现申请已提交请等待"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } failure:^(NSError *error) {
                    
                }];
           
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)getYanZhengMAction:(UIButton *)sender {
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
        //请求
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=set_cash_account&mobile=%@",sendMessage,_phone.text] parameters:@{} success:^(id responseObject) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
            
        } failure:^(NSError *error) {
            
        }];

}



@end
